// $origin: https://github.com/rolfschmidt/advent-of-code

module main

import os

fn day01a() int {
	numbers := read_day('1.input').map(it.int())
	for number1 in numbers {
		for number2 in numbers {
			if number1 + number2 == 2020 {
				return number1 * number2
			}
		}
	}
	return 0
}

fn day01b() int {
	numbers := read_day('1.input').map(it.int())
	for number1 in numbers {
		for number2 in numbers {
			for number3 in numbers {
				if number1 + number2 + number3 == 2020 {
					return number1 * number2 * number3
				}
			}
		}
	}
	return 0
}

fn read_day_string(path string) string {
	mut data := os.read_file(path) or { panic(err) }
	return data.trim(' \n\t\v\f\r')
}

fn read_day(path string) []string {
	return read_day_string(path).split_into_lines()
}

fn main() {
	println(day01a())
	println(day01b())
}
