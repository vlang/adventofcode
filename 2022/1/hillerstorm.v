import os { read_file }
import arrays { max, sum }

// https://github.com/hillerstorm/aoc2022-v/blob/main/days/day_01.v
fn main() {
	input := read_file('calories.input')!
	mut mapped_elves := input.split('\n\n')
		.map(sum(it.split_into_lines()
			.map(it.int()))!)

	mapped_elves.sort(b < a)

	println(max(mapped_elves)!)
	println(sum(mapped_elves[..3])!)
}
