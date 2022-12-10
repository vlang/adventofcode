import os { read_lines }
import arrays { flat_map }

// https://github.com/hillerstorm/aoc2022-v/blob/main/days/day_10.v
fn main() {
	instructions := flat_map[string, int](read_lines('crt.input')!, map_instruction)

	mut sprite_pos := 1

	mut part_one := 0
	mut part_two := '\n'

	for i, instruction in instructions {
		if i == 19 || (i - 19) % 40 == 0 {
			part_one += (i + 1) * sprite_pos
		}

		if i % 40 in [sprite_pos - 1, sprite_pos, sprite_pos + 1] {
			part_two += '#'
		} else {
			part_two += '.'
		}
		if (i + 1) % 40 == 0 {
			part_two += '\n'
		}

		sprite_pos += instruction
	}

	println(part_one)
	println(part_two)
}

fn map_instruction(line string) []int {
	parts := line.split(' ')
	match parts[0] {
		'addx' {
			return [0, parts[1].int()]
		}
		else {
			return [0]
		}
	}
}
