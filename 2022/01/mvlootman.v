import os
import arrays

fn main() {
	raw_input := os.read_file('calories.input')!
	input := process_input(raw_input)

	part1 := arrays.max(input) or { 0 }
	part2 := arrays.sum(input#[..3]) or { 0 }

	println('Part1: ${part1} \nPart2: ${part2}')
}

fn process_input(input string) []int {
	mut result := input
		.split('\n\n')
		.map(arrays.sum(it.split('\n').map(it.int())) or { 0 })
	result.sort(a > b)

	return result
}
