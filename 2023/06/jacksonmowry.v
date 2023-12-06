module main

import os
import math

fn main() {
	lines := os.read_lines('race_times.input')!
	mut times := lines[0].split(':')[1].split(' ').filter(it != '').map(it.u64())
	times << lines[0].split(':')[1].split('').filter(it != ' ').join('').u64()
	mut distances := lines[1].split(':')[1].split(' ').filter(it != '').map(it.u64())
	distances << lines[1].split(':')[1].split('').filter(it != ' ').join('').u64()
	mut product := 1
	mut part_2 := u64(0)

	for i := 0; i < times.len; i++ {
		a := f64(-1)
		b := f64(times[i])
		c := f64(-1) * f64(distances[i])
		discriminant := (b * b) - (4 * a * c)
		if discriminant == 0 {
			continue
		} else {
			mut lower := (-b + math.sqrt(discriminant)) / (2 * a)
			if math.ceil(lower) == lower {
				lower += 1
			}
			lower = math.ceil(lower)
			mut upper := (-b - math.sqrt(discriminant)) / (2 * a)
			if math.ceil(upper) == upper {
				upper -= 1
			}
			upper = math.floor(upper)
			if i == times.len - 1 {
				part_2 = u64(math.abs(upper - lower)) + 1
			} else {
				product *= int(math.abs(upper - lower)) + 1
			}
		}
	}
	println('Part 1: ${product}')
	println('Part 2: ${part_2}')
}
