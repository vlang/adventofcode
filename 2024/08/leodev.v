import os

fn main() {
	lines := os.read_lines('antennas.input')!
	size_y := lines.len
	size_x := lines[0].len

	mut frequencies := map[string][][2]int{}
	for y, line in lines {
		for x, ch in line {
			if ch == `.` {
				continue
			}
			frequencies[ch.ascii_str()] << [y, x]!
		}
	}

	mut antinodes1 := map[string]bool{}
	mut antinodes2 := map[string]bool{}
	for _, coords in frequencies {
		if coords.len < 2 {
			continue
		}
		for i in 0 .. coords.len {
			for j in i + 1 .. coords.len {
				vec := [coords[j][0] - coords[i][0], coords[j][1] - coords[i][1]]!
				for k in 0 .. 100 {
					pos1 := [coords[i][0] - vec[0] * k, coords[i][1] - vec[1] * k]!
					pos2 := [coords[j][0] + vec[0] * k, coords[j][1] + vec[1] * k]!
					if pos1[0] >= 0 && pos1[0] < size_y && pos1[1] >= 0 && pos1[1] < size_x {
						antinodes2['${pos1[0]},${pos1[1]}'] = true
						if k == 1 {
							antinodes1['${pos1[0]},${pos1[1]}'] = true
						}
					}
					if pos2[0] >= 0 && pos2[0] < size_y && pos2[1] >= 0 && pos2[1] < size_x {
						antinodes2['${pos2[0]},${pos2[1]}'] = true
						if k == 1 {
							antinodes1['${pos2[0]},${pos2[1]}'] = true
						}
					}
				}
			}
		}
	}

	for y, line in lines {
		for x, ch in line {
			if antinodes1['${y},${x}'] {
				print('#')
			} else {
				print(ch.ascii_str())
			}
		}
		print('\n')
	}

	println('part1: ${antinodes1.len}')
	println('part2: ${antinodes2.len}')
}
