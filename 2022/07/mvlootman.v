import os
import regex
import arrays

fn main() {
	lines := os.read_lines('filesystem.input')!
	mut path := ['root']
	mut filesizes := map[string]i64{} // 'path' -> total size path
	mut re := regex.regex_opt(r'\d+') or { panic(err) }

	for l in lines {
		if l.starts_with('$ ls') {
			// no operation needed
		} else if l.starts_with('$ cd /') {
			path = ['root']
		} else if l.starts_with('$ cd ..') {
			if path.len > 1 {
				path = unsafe { path#[..-1] }
			}
		} else if l.starts_with('$ cd ') {
			dir_name := l[5..]
			path << dir_name
		} else {
			if l.starts_with('dir') {
				filesizes[path.join('/')] += 0
			} else {
				size := re.find_all_str(l).map(it.int())[0]
				filesizes[path.join('/')] += size
			}
		}
	}

	// update parent level sizes to include child sizes
	keys := filesizes.keys()
	for i, j in keys {
		for k in keys[i + 1..] {
			if k.starts_with(j) {
				filesizes[j] += filesizes[k]
			}
		}
	}

	part1 := arrays.sum(filesizes.values().filter(it <= 100_000))!

	needed_space := 30_000_000 - (70_000_000 - filesizes['root']) // needed - ( total space - occupied)
	mut candidates := filesizes.values().filter(it >= needed_space)
	candidates.sort()
	part2 := candidates.first()

	println('Part1: ${part1}\nPart2: ${part2}')
}
