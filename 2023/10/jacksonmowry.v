module main

import os
import math

const up_symbols = [`F`, `7`, `|`]
const right_symbols = [`-`, `7`, `J`]
const down_symbols = [`|`, `J`, `L`]
const left_symbols = [`-`, `F`, `L`]

fn main() {
	part_1 := os.read_lines('pipe_maze-part1.input')!.map(it.split('').map(it[0]))
	count, _ := path_length(part_1)
	println('Part 1: ${count}')

	part_2 := os.read_lines('pipe_maze-part2.input')!.map(it.split('').map(it[0]))
	_, seen := path_length(part_2)
	area := internal_area(seen)
	println('Part 2: ${area}')
}

fn walk(input [][]u8, mut coord []int, seen [][]int) {
	current_symbol := input[coord[0]][coord[1]]
	match current_symbol {
		`|` {
			if ([coord[0] - 1, coord[1]] !in seen && input[coord[0] - 1][coord[1]] in up_symbols)
				|| (input[coord[0] - 1][coord[1]] == `S` && seen.len > 2) {
				coord[0] -= 1
			} else {
				coord[0] += 1
			}
		}
		`-` {
			if ([coord[0], coord[1] - 1] !in seen && input[coord[0]][coord[1] - 1] in left_symbols)
				|| (input[coord[0]][coord[1] - 1] == `S` && seen.len > 2) {
				coord[1] -= 1
			} else {
				coord[1] += 1
			}
		}
		`L` {
			if ([coord[0] - 1, coord[1]] !in seen && input[coord[0] - 1][coord[1]] in up_symbols)
				|| (input[coord[0] - 1][coord[1]] == `S` && seen.len > 2) {
				coord[0] -= 1
			} else {
				coord[1] += 1
			}
		}
		`J` {
			if ([coord[0] - 1, coord[1]] !in seen && input[coord[0] - 1][coord[1]] in up_symbols)
				|| (input[coord[0] - 1][coord[1]] == `S` && seen.len > 2) {
				coord[0] -= 1
			} else {
				coord[1] -= 1
			}
		}
		`7` {
			if ([coord[0] + 1, coord[1]] !in seen && input[coord[0] + 1][coord[1]] in down_symbols)
				|| (input[coord[0] + 1][coord[1]] == `S` && seen.len > 2) {
				coord[0] += 1
			} else {
				coord[1] -= 1
			}
		}
		`F` {
			if ([coord[0] + 1, coord[1]] !in seen && input[coord[0] + 1][coord[1]] in down_symbols)
				|| (input[coord[0] + 1][coord[1]] == `S` && seen.len > 2) {
				coord[0] += 1
			} else {
				coord[1] += 1
			}
		}
		else {}
	}
}

fn path_length(input [][]u8) (int, [][]int) {
	mut sr := -1
	mut sc := -1
	// Find S
	for i, line in input {
		for j, symbol in line {
			if symbol == `S` {
				sr = i
				sc = j
				break
			}
		}
	}
	mut directions := []int{}
	for {
		if input[sr - 1] or { [] }[sc] or { `.` } in up_symbols {
			directions << (sr - 1)
			directions << sc
			break
		}
		if input[sr] or { [] }[sc + 1] or { `.` } in right_symbols {
			directions << sr
			directions << (sc + 1)
			break
		}
		if input[sr + 1] or { [] }[sc] or { `.` } in down_symbols {
			directions << (sr + 1)
			directions << sc
			break
		}
		if input[sr] or { [] }[sc - 1] or { `.` } in left_symbols {
			directions << sr
			directions << (sc - 1)
			break
		}
	}
	mut seen := [[sr, sc]]
	mut count := 1
	for directions != [sr, sc] {
		seen << directions.clone()
		walk(input, mut directions, seen)
		count++
	}
	return count / 2, seen
}

fn internal_area(seen [][]int) int {
	// Shoelace formula
	mut area := 0.0
	for i := 0; i < seen.len - 1; i++ {
		area += (seen[i][0] * seen[i + 1][1]) - (seen[i + 1][0] * seen[i][1])
	}
	area += (seen.last()[0] * seen[0][1]) - (seen[0][0] * seen.last()[1])

	// Pick's theorem
	area = math.abs(area) / 2
	return (int(area) + 1) - ((seen.len) / (2))
}
