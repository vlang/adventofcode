module main

import arrays
import os

const numbers = [
	'0',
	'1',
	'2',
	'3',
	'4',
	'5',
	'6',
	'7',
	'8',
	'9',
	'zero',
	'one',
	'two',
	'three',
	'four',
	'five',
	'six',
	'seven',
	'eight',
	'nine',
]

struct Match {
	value string
	idx   int
}

fn main() {
	part_one := arrays.sum(os.read_lines('trebuchet-part1.input')!
		.map(it.split('').filter(it in numbers[..10]))
		.filter(it.len > 0)
		.map((it.first() + it.last()).int()))!

	part_two := arrays.sum(os.read_lines('trebuchet-part2.input')!
		.map(fn (line string) int {
			mut first_indices := numbers
				.filter(line.index(it) or { -1 } > -1)
				.map(Match{it, line.index(it) or { -1 }})
			first_indices.sort(a.idx < b.idx)
			first_num := numbers[numbers.index(first_indices.first().value) % 10]

			mut last_indices := numbers
				.filter(line.index(it) or { -1 } > -1)
				.map(Match{it, line.last_index(it) or { -1 }})
			last_indices.sort(a.idx < b.idx)
			last_num := numbers[numbers.index(last_indices.last().value) % 10]

			return (first_num + last_num).int()
		}))!

	println('Part 1: ${part_one}')
	println('Part 2: ${part_two}')
}
