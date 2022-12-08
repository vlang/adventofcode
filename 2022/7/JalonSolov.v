import os

const (
	c100k = 100_000
	c70b = 70_000_000
	c30b = 30_000_000
)

mut dir_sizes := map[string]i64{}
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
			size := l.i64()
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

mut total := i64(0)
unused := c70b - dir_sizes['/']
mut values := dir_sizes.values().filter(it + unused >= c30b)

values.sort(b > a)

for _, val in dir_sizes {
	if val <= c100k {
		total += val
	}
}

println(total)

println(values[0])
