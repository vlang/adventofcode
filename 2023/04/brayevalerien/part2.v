module main

import os
import arrays
import math

fn main() {
	input_path := '../scratchcards.input'

	lines := os.read_lines(input_path) or { panic('Could not read input file.') }
	mut copies := []int{len: lines.len, init: 1} // number of remaining copies per card
	for i in 0 .. lines.len {
		line := lines[i]
		winning := get_winning(line)
		nums := get_nums(line)
		for j in i + 1 .. math.min(i + 1 + matches(winning, nums), lines.len) {
			copies[j] += 1 * copies[i]
		}
	}
	println('Final result: ${arrays.sum(copies)!}')
}

fn get_winning(line string) []int {
	card := line.split(': ')[1].split(' | ')
	winning_str := card[0].split(' ')
	mut winning := []int{}
	for s in winning_str {
		if s != '' {
			winning << s.int()
		}
	}
	return winning
}

fn get_nums(line string) []int {
	card := line.split(': ')[1].split(' | ')
	nums_str := card[1].split(' ')
	mut nums := []int{}
	for s in nums_str {
		if s != '' {
			nums << s.int()
		}
	}
	return nums
}

// Number of winning numbers in a card
fn matches(winning []int, nums []int) int {
	mut matched := 0 // count of matched numbers
	for num in nums {
		if num in winning {
			matched += 1
		}
	}
	return matched
}
