module main

import math
import os

const bag = {
	'red':   12
	'green': 13
	'blue':  14
}

fn main() {
	mut part_one := 0
	mut part_two := 0

	for line in os.read_lines('cube.input')! {
		parts := line.split(': ')

		mut valid := true
		mut min_red := 0
		mut min_green := 0
		mut min_blue := 0

		for set in parts[1].split('; ') {
			for cube in set.split(', ') {
				cube_parts := cube.split(' ')
				color := cube_parts[1]
				count := cube_parts[0].int()

				if color == 'red' {
					min_red = math.max(min_red, count)
				} else if color == 'green' {
					min_green = math.max(min_green, count)
				} else if color == 'blue' {
					min_blue = math.max(min_blue, count)
				}

				if bag[color] < count {
					valid = false
				}
			}
		}

		if valid {
			part_one += parts[0].split(' ')[1].int()
		}

		part_two += min_red * min_green * min_blue
	}

	println('Part 1: ${part_one}')
	println('Part 2: ${part_two}')
}
