module main

import os

fn main() {
	parts := os.read_lines('race_times.input')!.map(it.split(': ')[1].split(' ').filter(it != ''))

	part_one := solve_wins(parts[0].map(it.u64()), parts[1].map(it.u64()))
	part_two := solve_wins([parts[0].join('').u64()], [parts[1].join('').u64()])

	println('Part 1: ${part_one}')
	println('Part 2: ${part_two}')
}

fn solve_wins(times []u64, distances []u64) u64 {
	mut result := u64(1)
	for game in 0 .. times.len {
		time := times[game]
		distance := distances[game]

		mut wins := u64(0)
		for msec in u64(1) .. time {
			if (time - msec) * msec > distance {
				wins++
			}
		}

		result *= wins
	}

	return result
}
