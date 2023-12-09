module main

import os

fn main() {
	mut forward := 0
	mut backward := 0

	lines := os.read_lines('mirage_maintenance.input')!.map(it.split(' ').map(it.int()))

	for line in lines {
		forward += (next_value(line, false))
		backward += (next_value(line, true))
	}
	println('Part 1: ${forward}')
	println('Part 2: ${backward}')
}

fn next_value(input []int, part_2 bool) int {
	if input.all(it == 0) {
		return 0
	}
	mut diff := []int{}
	for i := 0; i < input.len - 1; i++ {
		diff << input[i + 1] - input[i]
	}
	if part_2 {
		return input.first() - next_value(diff, part_2)
	} else {
		return input.last() + next_value(diff, part_2)
	}
}
