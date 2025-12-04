module main

import os
import strconv

fn main() {
	codes := os.read_file('kylepritchard.input') or { panic('Failed to read file') }

	mut start := 50
	mut count := 0
	mut count2 := 0

	for line in codes.split_into_lines() {
		if line.len == 0 {
			continue
		}

		if line[0] == `L` {
			move_str := line[1..].trim_space()
			mut move := strconv.atoi(move_str) or { 0 }

			for move > 0 {
				start--
				if start == 0 {
					count2++
				}
				if start == -1 {
					start = 99
				}
				move--
			}

			if start == 0 {
				count++
			}
		} else {
			move_str := line[1..].trim_space()
			mut move := strconv.atoi(move_str) or { 0 }

			for move > 0 {
				start++
				if start == 100 {
					start = 0
				}
				if start == 0 {
					count2++
				}
				move--
			}

			if start == 0 {
				count++
			}
		}
	}

	println('Part 1: $count')
	println('Part 2: $count2')
}
