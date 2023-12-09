module main

import os

fn main() {
	mut forward := 0
	mut backward := 0

	lines := os.read_lines('mirage_maintenance.input')!.map(it.split(' ').map(it.int()))

	for line in lines {
		front, back := next_value(line)
		backward += front
		forward += back
	}
	println('Part 1: ${forward}')
	println('Part 2: ${backward}')
}

fn next_value(input []int) (int, int) {
	if input.all(it == 0) {
		return 0, 0
	}
	mut diff := []int{}
	for i := 0; i < input.len - 1; i++ {
		diff << input[i + 1] - input[i]
	}
	front, back := next_value(diff)
	return input.first() - front, input.last() + back
}
