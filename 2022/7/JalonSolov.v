import os
import arrays

const c100k = 100_000
const c70m = 70_000_000
const c30m = 30_000_000

mut dir_sizes := map[string]int{}
mut curdir := ''

lines := os.read_lines('filesystem.input')!

for l in lines {
	match l[..4] {
		'$ cd' {
			match l[5..] {
				'/' {
					curdir = '/'
				}
				'..' {
					curdir = os.dir(curdir)
				}
				else {
					curdir = os.join_path_single(curdir, l[5..])
				}
			}
		}
		'$ ls', 'dir ' {
			// ignore
		}
		else {
			size := l.int()
			mut key := curdir
			for {
				dir_sizes[key] += size

				if key == '/' {
					break
				}

				key = os.dir(key)
			}
		}
	}
}

mut values := dir_sizes.values().filter(it <= c100k)

println(arrays.sum(values) or { 0 })

unused := c70m - dir_sizes['/']
values = dir_sizes.values().filter(it + unused >= c30m)

values.sort()

println(values[0])
