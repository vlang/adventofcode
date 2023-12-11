module main

import arrays
import os

fn main() {
	lines := os.read_lines('mirage_maintenance.input')!.map(it.split(' ').map(it.int()))

	mut part_one := 0
	mut part_two := 0

	for line in lines {
		mut diffs := arrays.window(line, size: 2).map(it[1] - it[0])
		mut first_numbers := [line[0], diffs[0]]
		part_one += line.last() + diffs.last()

		for {
			diffs = arrays.window(diffs, size: 2).map(it[1] - it[0])
			part_one += diffs.last()

			if diffs.all(it == 0) {
				break
			}

			first_numbers << diffs[0]
		}

		part_two += foldr(first_numbers, 0, fn (acc int, value int) int {
			return value - acc
		})
	}

	println('Part 1: ${part_one}')
	println('Part 2: ${part_two}')
}

fn foldr[T, R](array []T, init R, fold_op fn (acc R, elem T) R) R {
	mut value := init

	for i := array.len - 1; i >= 0; i-- {
		value = fold_op(value, array[i])
	}

	return value
}
