module main

import os

fn main() {
	part_1 := os.read_lines('trebuchet-part1.input')!
	part_2 := os.read_lines('trebuchet-part2.input')!
	println('Part 1: ${solver(part_1, false)}')
	println('Part 2: ${solver(part_2, true)}')
}

// Part 2
fn solver(lines []string, part_2 bool) int {
	mut total := 0
	for line in lines {
		mut coord := 0
		for i := 0; i < line.len; i++ {
			if line[i].is_digit() {
				coord += line[i].ascii_str().int() * 10
				break
			} else if part_2 {
				coord += is_digit_string(line, i) or { continue } * 10
				break
			}
		}
		for i := line.len - 1; i >= 0; i-- {
			if line[i].is_digit() {
				coord += line[i].ascii_str().int()
				break
			} else if part_2 {
				coord += is_digit_string(line, i) or { continue }
				break
			}
		}
		total += coord
	}
	return total
}

fn is_digit_string(line string, pos int) !int {
	digit_strings := ['one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine']
	for i, num in digit_strings {
		slice := line.substr_with_check(pos, pos + num.len) or { continue }
		if slice == num {
			return i + 1
		}
	}
	return error('')
}
