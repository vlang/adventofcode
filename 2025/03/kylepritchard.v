module main

import os
import strconv

fn max_sequence(s string, k int) string {
	to_remove := s.len - k
	mut remove_left := to_remove

	mut stack := []u8{len: 0, cap: s.len}

	for i in 0 .. s.len {
		c := s[i]
		for stack.len > 0 && remove_left > 0 && stack[stack.len - 1] < c {
			stack.delete_last()
			remove_left--
		}
		stack << c
	}

	if remove_left > 0 {
		stack = stack[..stack.len - remove_left].clone()
	}

	if stack.len > k {
		stack = stack[..k].clone()
	}

	return stack.bytestr()
}

fn main() {
	content := os.read_file('banks.input') or { panic('Failed to read file: ${err}') }
	lines := content.split_into_lines()

	// Part 1
	mut total_joltage := i64(0)
	for line in lines {
		if line.len == 0 {
			continue
		}

		seq := max_sequence(line, 2)
		if seq.len == 0 {
			continue
		}

		num := strconv.parse_int(seq, 10, 64) or { 0 }
		total_joltage += num
	}

	println('Part 1: ${total_joltage}')

	// Part 2
	total_joltage = 0
	for line in lines {
		if line.len == 0 {
			continue
		}

		seq := max_sequence(line, 12)
		if seq.len == 0 {
			continue
		}

		num := strconv.parse_int(seq, 10, 64) or { 0 }
		total_joltage += num
	}

	println('Part 2: ${total_joltage}')
}
