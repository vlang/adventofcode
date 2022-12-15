import datatypes { Stack }
import math { max }
import os { read_file }

// https://github.com/hillerstorm/aoc2022-v/blob/main/days/day_13.v
fn main() {
	pairs := read_file('distress_signal.input')!
		.trim_space()
		.split('\n\n')
		.map(it
			.split_into_lines()
			.map(parse_items(it.runes())!))

	mut part_one := 0
	for i, pair in pairs {
		if compare(&pair[0], &pair[1]) != 1 {
			part_one += (i + 1)
		}
	}

	mut joined := []Item{}
	for pair in pairs {
		joined << pair[0]
		joined << pair[1]
	}

	divider_packets := ['[[2]]', '[[6]]']
	joined << divider_packets.map(parse_items(it.runes())!)
	joined.sort_with_compare(compare)

	mut part_two := 1
	for i, items in joined {
		if items.str() in divider_packets {
			part_two *= (i + 1)
		}
	}

	println(part_one)
	println(part_two)
}

fn compare(left &Item, right &Item) int {
	if left is []Item && right is []Item {
		return compare_arrays(left, right)
	} else if left is []Item && right is int {
		return compare_arrays(left, [right])
	} else if left is int && right is []Item {
		return compare_arrays([left], right)
	} else if left is int && right is int {
		if left < right {
			return -1
		} else if right < left {
			return 1
		}
	}

	return 0
}

fn compare_arrays(left []Item, right []Item) int {
	for i := 0; i < max(left.len, right.len); i += 1 {
		if i >= left.len {
			return -1
		} else if i >= right.len {
			return 1
		}

		result := compare(&left[i], &right[i])
		if result != 0 {
			return result
		}
	}

	return 0
}

type Item = []Item | int

fn (item Item) str() string {
	return match item {
		int { item.str() }
		[]Item { '[' + item.map(it.str()).join(',') + ']' }
	}
}

fn parse_items(line []rune) !Item {
	mut array_stack := Stack[[]Item]{}

	for i := 0; i < line.len; i += 1 {
		match line[i] {
			`[` {
				array_stack.push([]Item{})
			}
			`]` {
				mut finished := array_stack.pop()!

				if array_stack.is_empty() {
					return Item(finished)
				} else {
					mut current := array_stack.pop()!

					current << Item(finished)
					array_stack.push(current)
				}
			}
			`0`...`9` {
				mut current := array_stack.pop()!

				if i < line.len - 1 && line[i + 1] >= `0` && line[i + 1] <= `9` {
					current << [line[i], line[i + 1]].string().int()
					i += 1
				} else {
					current << [line[i]].string().int()
				}

				array_stack.push(current)
			}
			else {}
		}
	}

	return array_stack.pop()!
}
