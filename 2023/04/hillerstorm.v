module main

import arrays
import math
import os

fn main() {
	mut part_one := i64(0)

	mut cards := map[int]int{}
	mut max_real_id := 0

	for line in os.read_lines('scratchcards.input')! {
		parts := line.split(': ')
		numbers := parts[1].split(' | ')
		winning_numbers := numbers[0].split(' ').filter(it.len > 0).map(it.int())
		own_numbers := numbers[1].split(' ').filter(it.len > 0).map(it.int())
		matching_numbers := own_numbers.filter(it in winning_numbers).len

		card := parts[0].split(' ').last().int()
		cards[card] += 1
		max_real_id = math.max(max_real_id, card)

		for id in []int{len: matching_numbers, init: card + index + 1} {
			cards[id] += cards[card]
		}

		part_one += math.powi(2, matching_numbers) / 2
	}

	part_two := arrays.sum(cards.keys().filter(it <= max_real_id).map(cards[it]))!

	println('Part 1: ${part_one}')
	println('Part 2: ${part_two}')
}
