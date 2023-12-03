import os
import v.util.diff
import rand
import time
import term

const diff_cmd = diff.find_working_diff_command() or { '' }

const wd = os.getwd()

const vexe = @VEXE

const skip_list = [
	'do_not_delete',
]

fn vrun(v_file string) !(string, time.Duration, time.Duration) {
	local_file_name := os.file_name(v_file)
	vdir := os.dir(v_file)
	executable_name := local_file_name.replace('.v', '.exe')

	sw_compilation := time.new_stopwatch()
	compilation := os.execute('${vexe} -o ${executable_name} ${local_file_name}')
	compile_time_took := sw_compilation.elapsed()
	if compilation.exit_code != 0 {
		return error('could not compile: `v ${local_file_name}` in working folder: "${vdir}", compilation output:\n${compilation.output}')
	}

	sw_running := time.new_stopwatch()
	res := os.execute('./${executable_name}')
	run_time_took := sw_running.elapsed()
	if res.exit_code != 0 {
		return error('could not run: `${executable_name}` in working folder: "${vdir}"')
	}

	return res.output, compile_time_took, run_time_took
}

fn v_file2out_file(v_file string) string {
	return os.real_path(os.join_path(wd, 'known_outputs', v_file.replace('.v', '.out')))
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
		base_ref := 'origin/main'
		ref := 'HEAD'
		git_diff_cmd := 'git --no-pager diff --name-only ${base_ref} ${ref}'
		eprintln(git_diff_cmd)
		changes := os.execute(git_diff_cmd).output.split_into_lines()
		dump(changes)
		files := changes.filter(it.ends_with('.v') && it.starts_with('20'))
		if files.len > 0 {
			println('running only a subset of all tests, based on the git diff for the new/changed solutions, compared to the main origin branch: ${files}')
			flush_stdout()
			return files
		}
	}

	glob_pattern := '*' + os.args[1] or { '' } + '*'
	if glob_pattern == '**' {
		println('Note: you can also `v run verify.v PATTERN`, where PATTERN can be any part of the .v filepath, like: `v run verify.v 2022` or `v run verify.v Jalon` etc.')
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

fn main() {
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
	for idx, v_file in v_files {
		os.chdir(wd)!
		if !os.exists(v_file) {
			// in the case of a CI diff, the file may have been deleted
			eprintln('> skipping missing file ${v_file}')
			continue
		}
		vdir := os.dir(v_file)
		os.chdir(vdir)!

		print('[${idx + 1:3}/${v_files.len:-3}] checking ${v_file:-25} with ${v_file2relative_out_file(v_file):-40} ...')
		flush_stdout()

		output, compilation_took, running_took := vrun(v_file) or {
			println('\n>>>>> error: ${err}')
			flush_stdout()
			erroring_files << v_file
			continue
		}
		total_compilation_time = total_compilation_time + compilation_took
		total_running_time = total_running_time + running_took
		ctook := '${compilation_took.milliseconds():4} ms'
		rtook := '${running_took.milliseconds():5} ms'
		println(' took ${term.green(ctook)} to compile, and ${term.bright_green(rtook)} to run.')
		flush_stdout()

		known, is_new := vout(v_file, output)!
		if is_new {
			eprintln('> .out file for ${v_file} does not exist, creating it based on the current run output...')
			new_files << v_file
		}
		if output != known {
			eprintln('current output does not match the known one:')
			eprintln('v_file: ${v_file}')
			eprintln('current output:\n${output}')
			eprintln('  known output:\n${known}')
			eprintln(diff.color_compare_strings(diff_cmd, rand.ulid(), output, known))
			erroring_files << v_file
		}
	}
	ctook := '${total_compilation_time.milliseconds():6} ms'
	rtook := '${total_running_time.milliseconds():6} ms'
	println('Total compilation time: ${term.green(ctook)} ; Total running time: ${term.bright_green(rtook)}')

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
