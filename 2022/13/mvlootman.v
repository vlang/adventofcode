import os
import datatypes
import math
import arrays

type Item = []Item | int

enum OrderingState {
	unknown = 0
	right   = -1
	wrong   = 1
}

struct Pair {
	left  Item
	right Item
}

fn main() {
	pairs := os.read_file('distress_signal.input')!
		.split('\n\n')
		.map(it.split('\n'))
		.map(Pair{parse_line(it[0])!, parse_line(it[1])!})

	part1 := solve_part1(pairs)
	part2 := solve_part2(pairs)!

	println('Part 1: ${part1}')
	println('Part 2: ${part2}')
}

fn solve_part1(pairs []Pair) int {
	compare_results := pairs.map(compare(it.left, it.right))
	summed_index_right_order := arrays.fold_indexed[OrderingState, int](compare_results,
		0, fn (idx int, acc int, val OrderingState) int {
		return if val == .right { idx + 1 + acc } else { acc }
	})
	return summed_index_right_order
}

fn solve_part2(pairs []Pair) !int {
	mut items := []Item{}

	for pair in pairs {
		items << pair.left
		items << pair.right
	}

	packet_start := parse_line('[[2]]')!
	packet_end := parse_line('[[6]]')!
	items << [packet_start, packet_end]

	// OrderingState enum values are set specific to sort all right orders on top
	items.sort_with_compare(fn (a &Item, b &Item) int {
		return int(compare(a, b))
	})

	idx_start := items.index(packet_start) + 1
	idx_end := items.index(packet_end) + 1

	return idx_start * idx_end
}

// compare takes two Items and returns if the ordering is correct
fn compare(left Item, right Item) OrderingState {
	// depending on the actual type of Item
	// both ints => direct compare
	// both arrays => compare arrays
	// one of the int other array => we wrap the naked element inside array and compare those as two arrays
	match left {
		[]Item {
			match right {
				[]Item { return compare_arrays(left, right) }
				int { return compare_arrays(left, [right]) }
			}
		}
		int {
			match right {
				[]Item {
					return compare_arrays([left], right)
				}
				int {
					if left < right {
						return .right
					} else if right < left {
						return .wrong
					}
				}
			}
		}
	}
	return .unknown
}

fn compare_arrays(left []Item, right []Item) OrderingState {
	max_len := math.max(left.len, right.len)
	for idx in 0 .. max_len {
		if idx >= left.len {
			return .right // ran out of items left
		} else if idx >= right.len {
			return .wrong // ran out of items right
		}

		compare_result := compare(left[idx], right[idx])
		if compare_result != .unknown {
			return compare_result
		}
	}
	return .unknown
}

fn parse_line(input string) !Item {
	mut stack := datatypes.Stack[[]Item]{}

	for idx, c in input {
		match c {
			`[` {
				// new array starts
				stack.push([]Item{})
			}
			`]` {
				mut last := stack.pop()!

				if stack.is_empty() {
					// if we have nothing left on stack we are done and can return the result
					return Item(last)
				} else {
					// otherwise there are sub-arrays and we add it to the prev item in stack
					mut current := stack.pop()!
					current << Item(last)
					stack.push(current)
				}
			}
			`,` {}
			else {
				mut current := stack.pop()!
				mut num_str := c.ascii_str()

				// assume numbers are no longer than 2 digits
				if idx + 1 < input.len {
					next_rune := input[idx + 1]
					match next_rune {
						`0`...`9` { num_str += next_rune.ascii_str() }
						else {}
					}
				}
				current << num_str.int()
				stack.push(current)
			}
		}
	}
	return stack.pop()! // should not reach this line
}
