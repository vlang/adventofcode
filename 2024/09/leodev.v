import os

fn main() {
	line := os.read_file('diskmap.input')!

	mut layout := []int{}
	for i := 0; i < line.len; i += 2 {
		file_len := line[i] - `0`
		for _ in 0 .. file_len {
			layout << (i >> 1)
		}

		if i + 1 >= line.len {
			break
		}
		gap_len := line[i + 1] - `0`
		for _ in 0 .. gap_len {
			layout << -1
		}
	}

	print_layout(layout)

	mut l := 0
	mut r := layout.len - 1
	mut fragment := layout.clone()
	for {
		for fragment[l] != -1 {
			l++
		}
		for fragment[r] == -1 {
			r--
		}
		if l >= r {
			break
		}
		fragment[l] = fragment[r]
		fragment[r] = -1
	}

	print_layout(fragment)

	println('part1: ${checksum(fragment)}')

	mut compact := layout.clone()
	r = compact.len - 1
	outer: for {
		for r > 0 && compact[r] == -1 {
			r--
		}
		l = r
		file_type := compact[r] or { panic('impossible') }
		for l > 0 && compact[l - 1] == file_type {
			l--
		}
		if l == 0 {
			break
		}
		file_len := r - l + 1

		mut fl := 0
		for {
			for fl < compact.len && compact[fl] != -1 {
				fl++
			}
			mut fr := fl
			for fr < compact.len && compact[fr] == -1 {
				fr++
			}
			if fr > l {
				r = l - 1
				continue outer
			}
			available := fr - fl
			if available >= file_len {
				break
			}
			fl = fr
		}

		for i in 0 .. file_len {
			compact[fl + i] = compact[r]
			compact[l + i] = -1
		}
	}

	print_layout(compact)

	println('part2: ${checksum(compact)}')
}

fn print_layout(layout []int) {
	for value in layout {
		if value != -1 {
			print(value)
		} else {
			print('.')
		}
	}
	print('\n')
}

fn checksum(layout []int) i64 {
	mut total := i64(0)
	for i, value in layout {
		if value != -1 {
			total += value * i
		}
	}
	return total
}
