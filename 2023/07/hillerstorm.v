module main

import arrays
import math
import os

struct Player {
	raw_hand              string
	hand_rank             int
	hand_rank_with_jokers int
	bet                   int
}

fn main() {
	card_labels := [`A`, `K`, `Q`, `J`, `T`, `9`, `8`, `7`, `6`, `5`, `4`, `3`, `2`]
	joker_labels := [`A`, `K`, `Q`, `T`, `9`, `8`, `7`, `6`, `5`, `4`, `3`, `2`, `J`]

	hands := os.read_lines('camel_cards.input')!
		.map(it.split(' '))
		.map(fn [joker_labels] (line []string) Player {
			runes := line[0].runes()
			return Player{
				raw_hand: line[0]
				hand_rank: rank_hand(runes)
				hand_rank_with_jokers: rank_with_jokers(runes, joker_labels#[..-1])
				bet: line[1].int()
			}
		})

	part_one := sum_scores(hands, card_labels, |p| p.hand_rank)
	part_two := sum_scores(hands, joker_labels, |p| p.hand_rank_with_jokers)

	println('Part 1: ${part_one}')
	println('Part 2: ${part_two}')
}

fn sum_scores(hands []Player, labels []rune, rank_func fn (player &Player) int) int {
	sorted := hands.sorted_with_compare(fn [labels, rank_func] (a &Player, b &Player) int {
		return sort_hands(a, b, labels, rank_func)
	})

	mut sum := 0
	for i in 0 .. sorted.len {
		sum += sorted[i].bet * (i + 1)
	}

	return sum
}

fn sort_hands(a Player, b Player, labels []rune, rank_func fn (player &Player) int) int {
	a_rank := rank_func(a)
	b_rank := rank_func(b)

	if a_rank == b_rank {
		for i in 0 .. a.raw_hand.len {
			if a.raw_hand[i] != b.raw_hand[i] {
				return labels.index(b.raw_hand[i]) - labels.index(a.raw_hand[i])
			}
		}
	}

	return b_rank - a_rank
}

fn rank_hand(hand []rune) int {
	values := arrays.map_of_counts(hand).values()
	if 5 in values {
		return 0
	} else if 4 in values {
		return 1
	} else if 3 in values {
		if 2 in values {
			return 2
		}

		return 3
	} else {
		pairs := values.filter(it == 2).len
		match pairs {
			2 { return 4 }
			1 { return 5 }
			else {}
		}
	}

	return 6
}

fn rank_with_jokers(hand []rune, labels []rune) int {
	if `J` !in hand {
		return rank_hand(hand)
	}

	mut top_rank := 6
	mut queue := [hand]
	for queue.len > 0 {
		curr := queue.pop()
		idx := curr.index(`J`)
		prefix := curr[..idx]
		suffix := curr[idx + 1..curr.len]

		for label in labels {
			mut new_hand := []rune{}
			new_hand << prefix
			new_hand << [label]
			new_hand << suffix

			if `J` in new_hand {
				queue << new_hand
			} else {
				top_rank = math.min(top_rank, rank_hand(new_hand))
				if top_rank == 0 {
					return top_rank
				}
			}
		}
	}

	return top_rank
}
