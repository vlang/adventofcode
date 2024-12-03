module main

import math
import os

fn main() {
	lines := os.get_lines()

	mut col1 := []i64{}
	mut col2 := []i64{}

	for l in lines {
		a, b := l.split_once('   ') or { panic('Could not split a line ${l}') }
		col1 << a.parse_int(10, 32)!
		col2 << b.parse_int(10, 32)!
	}

	col1.sort()
	col2.sort()

	mut sum := i64(0)
	for i := 0; i < col1.len; i++ {
		sum += math.abs(col2[i] - col1[i])
	}

	println(sum)
}
