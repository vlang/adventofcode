import os { read_file }

fn main() {
	inputs_part1 := read_file('calibration-part1.input')!.split_into_lines()
	println(part1(inputs_part1))
	inputs_part2 := read_file('calibration-part2.input')!.split_into_lines()
	println(part2(inputs_part2))
}

fn part1(inputs []string) int {
	mut sum := 0
	for line in inputs {
		mut first := 0
		mut last := 0
		for c in line {
			if c > `0` && c <= `9` {
				if first == 0 {
					first = c - u8(`0`)
				}
				last = c - u8(`0`)
			}
		}
		sum += first * 10 + last
	}
	return sum
}

fn part2(inputs []string) int {
	mut sum := 0
	replacers := ['1', 'one', '2', 'two', '3', 'three', '4', 'four', '5', 'five', '6', 'six', '7',
		'seven', '8', 'eight', '9', 'nine']
	values := ['one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine']
	for old_line in inputs {
		line := old_line.replace_each(replacers)
		reversed := line.reverse()

		mut first := 0
		mut first_index := 999
		mut last := 0
		mut last_index := 999
		for idx, value in values {
			if front_index := line.index(value) {
				if front_index < first_index {
					first = idx + 1
					first_index = front_index
				}
			}
			if back_index := reversed.index(value.reverse()) {
				if back_index < last_index {
					last = idx + 1
					last_index = back_index
				}
			}
		}
		sum += first * 10 + last
	}
	return sum
}
