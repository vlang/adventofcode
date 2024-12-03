module main

import os
import arrays

fn main() {
	input := os.get_lines()

	mut count := 0
	for line in input {
		levels := line.split(' ').map(it.int())
		for i := 0; i < levels.len; i++ {
			mut lvl := levels.clone()
			lvl.delete(i)
			diff := arrays.window(lvl, size: 2).map(it[1] - it[0])
			within_bounds := diff.all(it <= 3 && it >= -3)
			positive := diff.all(it > 0)
			negative := diff.all(it < 0)
			if within_bounds && (positive || negative) {
				count++
				break
			}
		}
	}

	println(count)
}
