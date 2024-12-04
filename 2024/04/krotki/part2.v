module main

import os

fn main() {
	input := os.get_raw_lines()

	xmax := input[0].len
	ymax := input.len

	mut count := 0
	for y, line in input {
		for x, c in line.bytes() {
			if x <= 0 || x >= xmax - 1 || y <= 0 || y >= ymax - 1 {
				continue
			}
			if c == `A` {
				// /
				diag1 := (input[y - 1][x - 1] == `M` && input[y + 1][x + 1] == `S`)
					|| (input[y - 1][x - 1] == `S` && input[y + 1][x + 1] == `M`)
				// \
				diag2 := (input[y + 1][x - 1] == `M` && input[y - 1][x + 1] == `S`)
					|| (input[y + 1][x - 1] == `S` && input[y - 1][x + 1] == `M`)
				if diag1 && diag2 {
					count++
				}
			}
		}
	}

	println(count)
}
