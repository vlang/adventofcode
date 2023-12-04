module main

import os
import arrays

fn main() {
	lines := os.read_lines('scratchcards.input')!
	mut part_1 := lines.map(it.split(': ')[1])
		.map(it.split('|').map(it.trim_space().split(' ').filter(it != '').map(it.int())))
		.map(arrays.concat(it[0], ...it[1]))
		.map(it.sorted())
		.map(arrays.uniq_only_repeated(it).len)
	println('Part 1: ${arrays.sum(part_1.filter(it != 0).map(1 << (it - 1)))!}')

	mut counts := []int{len: lines.len, init: 1}
	for i := 0; i < part_1.len; i++ {
		for j := 1; j <= part_1[i]; j++ {
			counts[i + j] += counts[i]
		}
	}
	println('Part 2: ${arrays.sum[int](counts)!}')
}
