import os
import v.util.diff
import rand

const diff_cmd = diff.find_working_diff_command() or { '' }

const wd = os.getwd()

const vexe = @VEXE

const skip_list = [
	'do_not_delete',
]

fn vrun(v_file string) !string {
	local_file_name := os.file_name(v_file)
	vdir := os.dir(v_file)
	res := os.execute('${vexe} run ${local_file_name}')
	if res.exit_code != 0 {
		return error('could not: `v run ${local_file_name}` in working folder: "${vdir}"')
	}
	return res.output
}

fn vout(v_file string, output string) !string {
	local_file_name := os.file_name(v_file)
	out_file := local_file_name.replace('.v', '.out')
	if !os.exists(out_file) {
		eprintln('> .out file for ${v_file} does not exist, creating it based on the current run output...')
		os.write_file(out_file, output)!
	}
	return os.read_file(out_file)!
}

fn main() {
	mut v_files := os.walk_ext('2022', '.v')
	v_files.sort()
	for v_file in v_files {
		if v_file in skip_list {
			eprintln('> skipping known failing ${v_file} ...')
			continue
		}
		os.chdir(wd)!
		vdir := os.dir(v_file)
		os.chdir(vdir)!
		println('> checking ${v_file} ...')
		output := vrun(v_file)!
		known := vout(v_file, output)!
		if output != known {
			eprintln('current output does not match the known one:')
			eprintln('v_file: ${v_file}')
			eprintln('current output:\n${output}')
			eprintln('  known output:\n${known}')
			eprintln(diff.color_compare_strings(diff_cmd, rand.ulid(), output, known))
			exit(1)
		}
	}
}
