module main

import os

fn main() {
	lines := os.read_lines('scratchcards.input')!
	mut part_1 := 0
	mut match_counts := []int{cap: lines.len}
	for line in lines {
		matches := count_matches(line)
		match_counts << matches
		if matches > 0 {
			part_1 += 1 << (matches - 1)
		}
	}
	println('Part 1: ${part_1}')

	mut counts := []int{len: lines.len, init: 1}
	for i, matches in match_counts {
		last_won_card := if i + matches < counts.len { i + matches } else { counts.len - 1 }
		for next_card := i + 1; next_card <= last_won_card; next_card++ {
			counts[next_card] += counts[i]
		}
	}
	mut part_2 := 0
	for count in counts {
		part_2 += count
	}
	println('Part 2: ${part_2}')
}

fn count_matches(line string) int {
	parts := line.split(': ')
	if parts.len != 2 {
		return 0
	}
	number_groups := parts[1].split(' | ')
	if number_groups.len != 2 {
		return 0
	}
	winning_numbers := number_groups[0].split(' ').filter(it.len > 0).map(it.int())
	owned_numbers := number_groups[1].split(' ').filter(it.len > 0).map(it.int())
	mut winning_lookup := map[int]bool{}
	for number in winning_numbers {
		winning_lookup[number] = true
	}
	mut matches := 0
	for number in owned_numbers {
		if number in winning_lookup {
			matches++
		}
	}
	return matches
}
