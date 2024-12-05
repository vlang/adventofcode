import os
import v.util.diff
import time
import term

const wd = os.getwd()

const vexe = @VEXE

const skip_list = [
	'do_not_delete',
]

fn vrun(v_file string) !(string, time.Duration, time.Duration) {
	local_file_name := os.file_name(v_file)
	vdir := os.dir(v_file)
	executable_name := local_file_name.replace('.v', '.exe')
	mut input_files := []string{}
	input_files << os.walk_ext('.', '.input')
	if input_files.len == 0 {
		input_files << os.walk_ext('..', '.input')
	}
	if input_files.len == 0 {
		eprintln('there should be *at least* 1 .input file in the folder ${vdir}, or in its parent folder.')
		return error('missing .input file')
	}

	compilation_cmd := '${vexe} -o ${executable_name} ${local_file_name}'
	sw_compilation := time.new_stopwatch()
	compilation := os.execute(compilation_cmd)
	compile_time_took := sw_compilation.elapsed()
	if compilation.exit_code != 0 {
		return error('could not compile: `v ${local_file_name}` in working folder: "${vdir}", compilation output:\n${compilation.output}')
	}
	mut run_time_took := 0 * time.nanosecond
	mut output := ''
	v_lines := os.read_lines(local_file_name)!
	skip_run := v_lines.any(it.starts_with('// verify: norun'))
	if !skip_run {
		input_file := find_proper_input_file(input_files, v_file)
		run_cmd := './${executable_name} < ${input_file}'
		$if trace_input_selection ? {
			println('\n>> v_file: ${v_file} | input_files: ${input_files} | input_file: ${input_file}')
		}
		sw_running := time.new_stopwatch()
		res := os.execute(run_cmd)
		run_time_took = sw_running.elapsed()
		if res.exit_code != 0 {
			return error('could not run: `${executable_name}` in working folder: "${vdir}"')
		}
		output = res.output
	}
	return output, compile_time_took, run_time_took
}

fn find_proper_input_file(input_files []string, v_file string) string {
	mut input_file := input_files.first()
	if v_file.ends_with('part1.v') {
		input_file = input_files.filter(it.ends_with('part1.input'))[0] or { input_file }
	}
	if v_file.ends_with('part2.v') {
		input_file = input_files.filter(it.ends_with('part2.input'))[0] or { input_file }
	}
	return input_file
}

fn v_file2out_file(v_file string) string {
	return os.real_path(os.join_path(wd, 'known', v_file.replace('.v', '.out')))
}

fn v_file2relative_out_file(v_file string) string {
	return v_file2out_file(v_file).replace(wd + '/', '')
}

fn vout(v_file string, output string) !(string, bool) {
	out_file := v_file2out_file(v_file)
	if !os.exists(out_file) {
		os.mkdir_all(os.dir(out_file))!
		os.write_file(out_file, output)!
		return output, true
	}
	return os.read_file(out_file)!, false
}

fn discover_files() ![]string {
	if os.getenv('CHANGED') != '' {
		git_diff_cmd := 'git --no-pager diff --name-only origin/main HEAD'
		eprintln(git_diff_cmd)
		changes := os.execute(git_diff_cmd).output.split_into_lines()
		dump(changes)
		files := changes.filter(it.ends_with('.v') && it.starts_with('20'))
		println('running only a subset of all tests, based on the git diff for the new/changed solutions, compared to the main origin branch: ${files}')
		return files
	}

	glob_pattern := '*' + os.args[1] or { '' } + '*'
	if glob_pattern == '**' {
		println('Note: you can also `v run verify.v PATTERN`, where PATTERN can be any part of the .v filepath,')
		println('like: `v run verify.v 2022` or `v run verify.v Jalon` etc.')
	}

	mut v_files := []string{}
	for folder in 2015 .. 2050 {
		unfiltered_files := os.walk_ext(folder.str(), '.v')
		for v_file in unfiltered_files {
			if glob_pattern != '**' && !v_file.match_glob(glob_pattern) {
				// eprintln('> skipping non matching ${v_file:-30} for glob pattern: `${glob_pattern}`')
				continue
			}
			if v_file in skip_list {
				eprintln('skipping known failing ${v_file} ...')
				continue
			}
			v_files << v_file
		}
	}

	return v_files
}

fn rm_gitkeep_sibling(sibling_file string) {
	keep_file := os.join_path(os.dir(sibling_file), '.gitkeep')
	if os.exists(keep_file) {
		os.rm(keep_file) or {}
	}
}

fn cleanup_gitkeep_files(v_file string) {
	rm_gitkeep_sibling(v_file)
	rm_gitkeep_sibling(v_file2out_file(v_file))
}

fn main() {
	start_time := time.now()
	unbuffer_stdout()
	mut v_files := discover_files()!
	v_files.sort_with_compare(fn (a &string, b &string) int {
		xa := a.split('/').map(if it.len == 1 { '0${it}' } else { it }).join('/')
		xb := b.split('/').map(if it.len == 1 { '0${it}' } else { it }).join('/')
		return int(xa < xb)
	})

	mut erroring_files := []string{}
	mut new_files := []string{}
	mut total_compilation_time := time.Duration(0)
	mut total_running_time := time.Duration(0)
	mut total_files := 0
	for idx, v_file in v_files {
		os.chdir(wd)!
		cleanup_gitkeep_files(v_file)
		if !os.exists(v_file) {
			// in the case of a CI diff, the file may have been deleted
			eprintln('> skipping missing file ${v_file}')
			continue
		}
		vdir := os.dir(v_file)
		os.chdir(vdir)!

		short_out_path := v_file2relative_out_file(v_file)#[-40..]
		print('[${idx + 1:3}/${v_files.len:-3}] checking ${v_file:-30} with ${short_out_path:-38} ...')

		output, compilation_took, running_took := vrun(v_file) or {
			println('\n>>>>> error: ${err}')
			erroring_files << v_file
			continue
		}
		total_compilation_time = total_compilation_time + compilation_took
		total_running_time = total_running_time + running_took
		ctook := '${compilation_took.milliseconds():4} ms'
		rtook := '${running_took.milliseconds():5} ms'
		if running_took == 0 {
			println(' took ${term.green(ctook)} to compile, ${term.bright_yellow('norun')}.')
		} else {
			println(' took ${term.green(ctook)} to compile, and ${term.bright_green(rtook)} to run.')
		}
		total_files++

		known, is_new := vout(v_file, output)!
		if is_new {
			eprintln('> .out file for ${v_file} does not exist, creating it based on the current run output...')
			new_files << v_file
		}
		if running_took != 0 && output != known {
			eprintln('current output does not match the known one:')
			eprintln('v_file: ${v_file}')
			eprintln('current output:\n${output}')
			eprintln('  known output:\n${known}')
			eprintln(diff.compare_text(output, known)!)
			erroring_files << v_file
		}
	}
	ctook := '${total_compilation_time.milliseconds():6} ms'
	rtook := '${total_running_time.milliseconds():6} ms'
	ttook := '${(time.now() - start_time).milliseconds():6} ms'
	println('Total time: ${term.magenta(ttook)} ; Total compilation time: ${term.green(ctook)} ; Total running time: ${term.bright_green(rtook)} ; Total files: ${term.bright_white(total_files.str())} .')

	if erroring_files.len > 0 {
		eprintln('Total files with errors: ${erroring_files.len}')
		for e in erroring_files {
			eprintln('   ${e}')
		}
		exit(1)
	}
	if new_files.len > 0 && os.getenv('CI') != '' {
		eprintln('Detected ${new_files.len} missing output files, you should run "v run verify.v" to generate output files')
		for n in new_files {
			eprintln('    v run verify.v ${n}')
		}
		exit(2)
	}
}
