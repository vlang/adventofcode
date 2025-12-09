module main

import os
import strconv

fn has_exact_two_halves(s string) bool {
	if s.len % 2 != 0 {
		return false
	}
	half := s.len / 2
	return s[0..half] == s[half..]
}

fn has_repeating_pattern(s string) bool {
	for pattern_len in 1 .. s.len / 2 + 1 {
		if s.len % pattern_len != 0 {
			continue
		}

		pattern := s[0..pattern_len]
		mut matches := true

		repetitions := s.len / pattern_len
		for rep in 1 .. repetitions {
			start := rep * pattern_len
			end := start + pattern_len
			if s[start..end] != pattern {
				matches = false
				break
			}
		}

		if matches {
			return true
		}
	}
	return false
}

fn main() {
	content := os.read_file('ids.input') or { panic('Failed to read file: ${err}') }

	ids := content.split(',')

	mut sum1 := i64(0)
	mut sum2 := i64(0)

	for id in ids {
		if id.len == 0 {
			continue
		}

		range_parts := id.split('-')

		start_str := range_parts[0].trim_space()
		end_str := range_parts[1].trim_space()

		start := strconv.parse_int(start_str, 10, 64) or {
			eprintln('Start number isn\'t valid: "${id}"')
			continue
		}

		end := strconv.parse_int(end_str, 10, 64) or {
			eprintln('End number isn\'t valid: "${id}"')
			continue
		}

		for num in start .. end + 1 {
			num_str := num.str()

			// Part 1
			if has_exact_two_halves(num_str) {
				sum1 += num
			}

			// Part 2
			if has_repeating_pattern(num_str) {
				sum2 += num
			}
		}
	}

	println('Part 1: ${sum1}')
	println('Part 2: ${sum2}')
}
