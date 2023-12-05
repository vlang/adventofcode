module main

import os
import arrays
// import math

fn main() {
	// input := os.read_file('seed_map.input')!
	input := os.read_file('personal.input')!
		.split('\n\n')
		.map(it.split_into_lines().map(it.trim_space()))
	mut seeds := (input[0][0].split(': ')[1]).split(' ').map(it.i64())
	for m in 1 .. 8 {
		maps := input[m][1..].map(it.split(' ').map(it.i64()))
		for i := 0; i < seeds.len; i++ {
			for line in maps {
				if seeds[i] >= line[1] && seeds[i] <= line[1] + line[2] {
					seeds[i] = line[0] + (seeds[i] - line[1])
					break
				}
			}
		}
	}

	println('Part 1: ${arrays.min(seeds)!}')

	mut seeds_2 := (input[0][0].split(': ')[1]).split(' ').map(it.i64())
	mut part_2_min := max_i64
	mut maps := [][][]i64{}
	for i in 1 .. 8 {
		maps << input[i][1..].map(it.split(' ').map(it.i64()))
	}
	for i := 0; i < seeds_2 - 2; i++ {
		start := seeds_2[i]
		end := start + seeds_2[i + 1] + 1
		for ; start < end; i++ {
		}
	}
	println('Part 2: ${part_2_min}')
	println('done')
}
