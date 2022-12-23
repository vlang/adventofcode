// $origin: https://github.com/rolfschmidt/advent-of-code

module main

import os

[inline]
fn d15_run(lines string, find int) int {
	mut spoken_before := map[int]int{}
	mut spoken := map[int]int{}
	mut numbers := lines.split(',')
	for i, number in numbers {
		spoken[number.int()] = i
	}
	mut current_number := 0
	mut last_number := numbers.last().int()
	mut last_index := 0
	mut last_index2 := 0
	for i := numbers.len - 1; i < find - 1; i++ {
		current_number = last_number
		if current_number !in spoken {
			last_number = 0
			spoken[current_number] = i
		} else {
			spoken_before[current_number] = spoken[current_number]
			spoken[current_number] = i
			last_index = spoken[current_number]
			last_index2 = spoken_before[current_number]
			if last_index == i && last_index2 == i - 1 {
				last_number = 1
			} else {
				last_number = ((last_index + 1) - (last_index2 + 1))
			}
		}
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
	//println(day15b())
}

fn read_day_string(path string) string {
	mut data := os.read_file(path) or { panic(err) }
	return data.trim(' \n\t\v\f\r')
}
