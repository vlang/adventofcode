module main

import os
import math

fn main() {
	input_path := 'scratchcards.input'

	lines := os.read_lines(input_path) or { panic('Could not read input file.') }
	mut sum := 0 // will contain the final result
	for line in lines {
		winning := get_winning(line)
		nums := get_nums(line)
		sum += card_value(winning, nums)
	}
	println('Final result: ${sum}')
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

fn card_value(winning []int, nums []int) int {
	mut matched := 0 // count of matched numbers
	for num in nums {
		if num in winning {
			matched += 1
		}
	}
	if matched == 0 {
		return 0
	}
	return int(math.pow(2, matched-1))
}
