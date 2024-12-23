import os

// vfmt off
const deltas = [[-1, 0]!, [1, 0]!, [0, -1]!, [0, 1]!, [-1, -1]!, [-1, 1]!, [1, -1]!, [1, 1]!]!
// vfmt on
const lines = os.read_lines('words.input')!

fn word_found(x int, y int, dir int) bool {
	mut adjusted_x := x
	mut adjusted_y := y

	for c in 'MAS' {
		adjusted_x += deltas[dir][0]
		adjusted_y += deltas[dir][1]

		if adjusted_x < 0 || adjusted_y < 0 || adjusted_x >= lines[0].len || adjusted_y >= lines.len
			|| lines[adjusted_y][adjusted_x] != c {
			return false
		}
	}

	return true
}

fn main() {
	mut xmas := 0
	mut x_mas := 0

	for y, line in lines {
		for x, c in line {
			match c {
				`X` {
					for dir in 0 .. deltas.len {
						if word_found(x, y, dir) {
							xmas++
						}
					}
				}
				`A` {
					if x > 0 && x < line.len - 1 && y > 0 && y < lines.len - 1 {
						if ((lines[y - 1][x - 1] == `M` && lines[y + 1][x + 1] == `S`)
							|| (lines[y - 1][x - 1] == `S` && lines[y + 1][x + 1] == `M`))
							&& ((lines[y - 1][x + 1] == `M` && lines[y + 1][x - 1] == `S`)
							|| (lines[y - 1][x + 1] == `S` && lines[y + 1][x - 1] == `M`)) {
							x_mas++
						}
					}
				}
				else {}
			}
		}
	}

	println('Part 1: ${xmas}')
	println('Part 2: ${x_mas}')
}
