module main

import os

fn main() {
	input_path := '../trebuchet-part2.input'

	lines := os.read_lines(input_path) or { panic('Could not read input file.') }
	mut sum := 0 // will contain the final result
	for line in lines {
		line_nums := get_line_nums(line)
		sum += get_line_number(line_nums)
	}
	println('Final result: ${sum}')
}

fn index(a []string, s string) int {
	mut i := 0
	for sp in a {
		if sp == s {
			return i
		} else {
			i += 1
		}
	}
	return -1
}

// Given a string, returns the array of all numbers in this string
// BUT! numbers can be spelled out with letters as well.
// e.g. 'xtwone3four' -> [`2`, `1`, `3`, `4`]
fn get_line_nums(line string) []rune {
	nums := []rune{len: 10, init: index.str()[0]}
	mut line_nums := []rune{}
	for i in 0 .. line.len {
		if rune(line[i]) in nums {
			line_nums << rune(line[i])
		} else {
			spelled_num := get_spelled_number(line[i..])
			if spelled_num != -1 {
				line_nums << spelled_num.str()[0]
			}
		}
	}
	return line_nums
}

// Given a string, returns the number that s starts with, or -1 if s does not start with a number
// e.g. 'xtwone3four' -> -1
//      'twone3four' -> `2`
//      '3four' -> -1
fn get_spelled_number(s string) int {
	spelled_nums := ['zero', 'one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine']
	min_len := 3 // minimum length of a spelled out number
	max_len := 5 // maximum length of a spelled out number
	for num_len in min_len .. (max_len + 1) {
		if num_len <= s.len {
			index_in_spelled_nums := index(spelled_nums, s[..num_len])
			if index_in_spelled_nums != -1 {
				return index_in_spelled_nums
			}
		} else {
			break
		}
	}
	return -1
}

// Given a array of digits as runes, returns the 2-digits number formed by
// the first digit in the array, concatenated with the last digit in the array.
fn get_line_number(nums []rune) int {
	// runes cannot be concatenated easily. So first cast to string, concatenate and cast to int.
	mut res := rune(nums[0]).str()
	res += rune(nums[nums.len - 1]).str()
	return res.int()
}
