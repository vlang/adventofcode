import os { read_file }
import arrays { sum }

struct Directory {
	name   string
	parent string
}

// https://github.com/hillerstorm/aoc2022-v/blob/main/days/day_07.v
fn main() {
	lines := read_file('filesystem.input')!.trim_space().split_into_lines()

	mut directories := {
		'/': Directory{
			name:   '/'
			parent: ''
		}
	}

	mut sub_directories := {
		'/': []string{}
	}

	mut directory_sizes := map[string]int{}
	mut file_sizes := map[string]int{}

	mut cwd := directories['/']

	for line in lines {
		match line[..4] {
			'$ cd' {
				relative_to_dir := line[5..]
				match relative_to_dir {
					'..' {
						if cwd.parent == '' {
							panic("Can't move up from root")
						}
						cwd = directories[cwd.parent]
					}
					cwd.name {} // Catches the case when the first line is `$ cd /`
					else {
						to_dir := '${cwd.name}${relative_to_dir}/'
						if to_dir in sub_directories[cwd.name] {
							cwd = directories[to_dir]
						} else {
							cwd = add_directory(mut directories, mut sub_directories,
								cwd, to_dir)
						}
					}
				}
			}
			'dir ' {
				name := '${cwd.name}${line[4..]}/'

				if name !in sub_directories[cwd.name] {
					add_directory(mut directories, mut sub_directories, cwd, name)
				}
			}
			'$ ls' {} // Do nothing, the next lines are the result
			else {
				parts := line.split(' ')
				file_size, file_name := parts[0].int(), '${cwd.name}${parts[1]}'
				if file_name !in file_sizes {
					file_sizes[file_name] = file_size
					update_directory_sizes(directories, mut directory_sizes, cwd, file_size)
				}
			}
		}
	}

	mut sizes := directory_sizes.values()
	part_one := sum(sizes.filter(it <= 100000))!

	remaining_space := 70000000 - directory_sizes['/']
	to_free := 30000000 - remaining_space
	sizes.sort()
	part_two := sizes.filter(it >= to_free).first()

	println(part_one.str())
	println(part_two.str())
}

fn add_directory(mut directories map[string]Directory, mut sub_directories map[string][]string, parent &Directory, name string) Directory {
	dir := Directory{
		name:   name
		parent: parent.name
	}
	directories[name] = dir
	sub_directories[parent.name] << name

	return dir
}

fn update_directory_sizes(directories map[string]Directory, mut directory_sizes map[string]int, directory &Directory, file_size int) {
	directory_sizes[directory.name] += file_size
	if directory.parent != '' {
		update_directory_sizes(directories, mut directory_sizes, directories[directory.parent],
			file_size)
	}
}
