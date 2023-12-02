import os { read_file }

const results = {
	'A': {
		'X': [3 + 1, 3 + 0]
		'Y': [6 + 2, 1 + 3]
		'Z': [0 + 3, 2 + 6]
	}
	'B': {
		'X': [0 + 1, 1 + 0]
		'Y': [3 + 2, 2 + 3]
		'Z': [6 + 3, 3 + 6]
	}
	'C': {
		'X': [6 + 1, 2 + 0]
		'Y': [0 + 2, 3 + 3]
		'Z': [3 + 3, 1 + 6]
	}
}

// https://github.com/hillerstorm/aoc2022-v/blob/main/days/day_02.v
fn main() {
	input := read_file('rock_paper_scissors.input')!
	mut part_one := 0
	mut part_two := 0

	for game in input.split_into_lines() {
		parts := game.split(' ')
		if parts.len != 2 {
			continue
		}
		points := results[parts[0]][parts[1]]
		part_one += points[0]
		part_two += points[1]
	}

	println(part_one)
	println(part_two)
}
