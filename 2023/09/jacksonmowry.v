module main

import os
import arrays

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
	diffs := arrays.flat_map_indexed[int, int](input, fn [input] (i int, e int) []int {
		return [input[i + 1] or { return [] } - input[i]]
	})
	front, back := next_value(diffs)
	return input.first() - front, input.last() + back
}
