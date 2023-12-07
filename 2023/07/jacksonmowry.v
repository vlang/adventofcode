module main

import os

const card_to_val = {
	`A`: 13
	`K`: 12
	`Q`: 11
	`J`: 10
	`T`: 9
	`9`: 8
	`8`: 7
	`7`: 6
	`6`: 5
	`5`: 4
	`4`: 3
	`3`: 2
	`2`: 1
}

const card_to_val_2 = {
	`A`: 13
	`K`: 12
	`Q`: 11
	`T`: 10
	`9`: 9
	`8`: 8
	`7`: 7
	`6`: 6
	`5`: 5
	`4`: 4
	`3`: 3
	`2`: 2
	`J`: 1
}

fn main() {
	filename := 'camel_cards.input'
	println('Part 1: ${solver(filename, false)!}')
	println('Part 2: ${solver(filename, true)!}')
}

fn solver(filename string, part_2 bool) !int {
	mut lines := os.read_lines(filename)!.map(it.split(' '))
	for i, hand in lines {
		mut counts := map[u8]int{}
		for card in hand[0] {
			counts[card]++
		}
		mut freq := []int{}
		mut j_count := 0
		for key, val in counts {
			if part_2 && key == `J` {
				j_count += val
			} else {
				freq << val
			}
		}
		if j_count == 5 {
			lines[i] << 7.str()
			continue
		}
		freq.sort(b < a)
		if part_2 {
			freq[0] += j_count
		}
		lines[i] << score_hand(freq)
	}
	if part_2 {
		lines.sort_with_compare(fn (mut a []string, mut b []string) int {
			if a[2] < b[2] {
				return -1
			} else if a[2] > b[2] {
				return 1
			}
			for i := 0; i < 5; i++ {
				if card_to_val_2[a[0][i]] == card_to_val_2[b[0][i]] {
					continue
				} else if card_to_val_2[a[0][i]] < card_to_val_2[b[0][i]] {
					return -1
				} else {
					return 1
				}
			}
			return 0
		})
	} else {
		lines.sort_with_compare(fn (mut a []string, mut b []string) int {
			if a[2] < b[2] {
				return -1
			} else if a[2] > b[2] {
				return 1
			}
			for i := 0; i < 5; i++ {
				if card_to_val[a[0][i]] == card_to_val[b[0][i]] {
					continue
				} else if card_to_val[a[0][i]] < card_to_val[b[0][i]] {
					return -1
				} else {
					return 1
				}
			}
			return 0
		})
	}
	mut sum := 0
	for i := 0; i < lines.len; i++ {
		sum += lines[i][1].int() * (i + 1)
	}
	return sum
}

fn score_hand(hand_counts []int) string {
	return match hand_counts[0] {
		5 {
			7.str()
		}
		4 {
			6.str()
		}
		3 {
			if hand_counts[1] == 2 {
				5.str()
			} else {
				4.str()
			}
		}
		2 {
			if hand_counts[1] == 2 {
				3.str()
			} else {
				2.str()
			}
		}
		1 {
			1.str()
		}
		else {
			panic('invalid card count')
		}
	}
}
