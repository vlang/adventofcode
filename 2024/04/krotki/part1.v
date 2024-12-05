module main

import os

fn main() {
	input := os.get_lines()

	dirs := [
		[0, 1],
		[0, -1],
		[1, 0],
		[-1, 0],
		[1, 1],
		[1, -1],
		[-1, 1],
		[-1, -1],
	]

	xmax := input[0].len
	ymax := input.len

	mut count := 0
	for y, line in input {
		for x, c in line.bytes() {
			if c == `X` {
				dirl: for dir in dirs {
					for dist, letter in 'MAS' {
						d := dist + 1
						dx := x + dir[0] * d
						dy := y + dir[1] * d
						if dx < 0 || dx >= xmax || dy < 0 || dy >= ymax || input[dy][dx] != letter {
							continue dirl
						}
						if d == 3 {
							count++
						}
					}
				}
			}
		}
	}

	println(count)
}
