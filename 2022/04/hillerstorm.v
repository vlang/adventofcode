import os { read_file }

// https://github.com/hillerstorm/aoc2022-v/blob/main/days/day_04.v
fn main() {
	pairs := read_file('assignments.input')!.split_into_lines()
		.map(it.split(',').map(it.split('-').map(it.int())))
		.map([
			range(it[0][0], it[0][1]),
			range(it[1][0], it[1][1]),
		])

	mut part_one := 0
	mut part_two := 0

	for pair in pairs {
		if pair[0].all(it in pair[1]) || pair[1].all(it in pair[0]) {
			part_one += 1
			part_two += 1
			continue
		} else if pair[0].any(it in pair[1]) || pair[1].any(it in pair[0]) {
			part_two += 1
		}
	}

	println(part_one)
	println(part_two)
}

fn range(from int, to int) []int {
	return []int{len: (to - from) + 1, init: index + from}
}
