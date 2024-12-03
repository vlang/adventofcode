module main

import os
import arrays

fn main() {
	lines := os.get_lines()
	mut col1 := []i64{}
	mut col2 := []i64{}

	for l in lines {
		a, b := l.split_once('   ') or { panic('Could not split a line ${l}') }
		col1 << a.parse_int(10, 32)!
		col2 << b.parse_int(10, 32)!
	}

	counts := arrays.map_of_counts[i64](col2)

	mut sum := i64(0)
	for n in col1 {
		sum += n * counts[n]
	}

	println(sum)
}
