// $origin: https://github.com/rolfschmidt/advent-of-code
// verify: norun
module main

import os

@[inline]
fn d15_run(lines string, find int) int {
	mut numbers := lines.split(',').map(it.int())
	mut last_number := numbers.last()
	mut position := 0
	mut positions := []int{len: find}
	for number in numbers {
		position += 1
		positions[number] = position
	}

	for position < find {
		last_position := positions[last_number]

		mut next_number := 0
		if last_position != 0 {
			next_number = position - last_position
		}

		positions[last_number] = position
		position += 1
		last_number = next_number
	}

	return last_number
}

fn day15a() int {
	mut lines := read_day_string('15.input')
	return d15_run(lines, 2020)
}

fn day15b() int {
	mut lines := read_day_string('15.input')
	return d15_run(lines, 30000000)
}

fn main() {
	println(day15a())
	println(day15b())
}

fn read_day_string(path string) string {
	mut data := os.read_file(path) or { panic(err) }
	return data.trim(' \n\t\v\f\r')
}
