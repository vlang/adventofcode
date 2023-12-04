module main

import arrays
import os

const digits = '0123456789'.runes()

fn main() {
	lines := os.read_lines('schematic.input')!

	width := lines[0].len + 2
	deltas := [
		-width - 1,
		-width,
		-width + 1,
		-1,
		1,
		width - 1,
		width,
		width + 1,
	]

	extra_row := '.'.repeat(width)
	mut padded := [extra_row]
	padded << lines.map('.${it}.')
	padded << extra_row

	grid := arrays.flatten(padded.map(it.runes()))

	mut part_one := 0

	mut digit := ''
	mut digit_indices := []int{}
	mut gears := map[int][]int{}
	for idx, chr in grid {
		if chr in digits {
			digit += chr.str()
			digit_indices << idx
			continue
		}

		if digit.len > 0 {
			digit_value := digit.int()
			if is_part(digit_indices, digit_value, grid, deltas, mut gears) {
				part_one += digit_value
			}
		}

		digit = ''
		digit_indices = []
	}

	part_two := arrays.sum(gears
		.keys()
		.filter(gears[it].len == 2)
		.map(arrays.reduce(gears[it], fn (a int, b int) int {
			return a * b
		})!))!

	println('Part 1: ${part_one}')
	println('Part 2: ${part_two}')
}

fn is_part(digit_indices []int, digit_value int, grid []rune, deltas []int, mut gears map[int][]int) bool {
	neighbours := digit_indices.map(fn [deltas] (i int) []int {
		return deltas.map(i + it)
	})

	mut result := false
	for idx in arrays.map_of_indexes[int](arrays.flatten(neighbours)).keys() {
		chr := grid[idx]
		if chr == `.` || chr in digits {
			continue
		} else if chr == `*` {
			gears[idx] << digit_value
		}
		result = true
	}

	return result
}
