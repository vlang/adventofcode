import os

fn main() {
	lines := os.read_lines('words.input')!

	mut occurences := 0
	mut occurences2 := 0
	target := 'XMAS'

	mut debug_map := map[string]bool{}

	for y in 0 .. lines.len {
		line := lines[y]
		for x in 0 .. line.len {
			ch := line[x]
			match ch {
				target[0] {
					for displacement in [
						[-1, 0]!, // upwards
						[1, 0]!, // downwards
						[0, 1]!, // forwards
						[0, -1]!, // backwards
						[-1, -1]!, // up left
						[-1, 1]!, // up right
						[1, -1]!, // down left
						[1, 1]!, // down right
					] {
						delta_y := displacement[0]
						delta_x := displacement[1]

						max_y := y + delta_y * (target.len - 1)
						max_x := x + delta_x * (target.len - 1)
						if max_y < 0 || max_y >= lines.len || max_x < 0 || max_x >= line.len {
							continue
						}

						mut matched := true
						for i in 1 .. target.len {
							ch2 := lines[y + delta_y * i][x + delta_x * i]
							if ch2 != target[i] {
								matched = false
								break
							}
						}
						if matched {
							for i in 0 .. target.len {
								debug_map['${y + delta_y * i}:${x + delta_x * i}'] = true
							}
							occurences++
						}
					}
				}
				`A` {
					if x < 1 || y < 1 || x >= line.len - 1 || y >= lines.len - 1 {
						continue
					}

					if ((lines[y - 1][x - 1] == `M` && lines[y + 1][x + 1] == `S`)
						|| (lines[y - 1][x - 1] == `S` && lines[y + 1][x + 1] == `M`))
						&& ((lines[y - 1][x + 1] == `M` && lines[y + 1][x - 1] == `S`)
						|| (lines[y - 1][x + 1] == `S` && lines[y + 1][x - 1] == `M`)) {
						occurences2++
					}
				}
				else {}
			}
		}
	}

	for y in 0 .. lines.len {
		for x in 0 .. lines[y].len {
			if debug_map['${y}:${x}'] {
				print(lines[y][x..x + 1])
			} else {
				print('.')
			}
		}
		print('\n')
	}

	println('part1: ${occurences}')
	println('part2: ${occurences2}')
}
