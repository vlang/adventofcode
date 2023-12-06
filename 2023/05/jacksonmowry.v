module main

import os
import arrays
import math

fn main() {
	input := os.read_file('seed_map.input')!
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

	mut seeds_2 := (input[0][0].split(': ')[1]).split(' ').map(it.u64())
	mut ranges := [][]u64{}
	for i := 0; i < seeds_2.len - 1; i += 2 {
		ranges << [seeds_2[i], seeds_2[i] + seeds_2[i + 1]]
	}
	mut maps := [][][]u64{}
	for i in 1 .. 8 {
		maps << input[i][1..].map(it.split(' ').map(it.u64()))
	}
	for mapx in maps {
		mut sub_ranges := [][]u64{}
		for ranges.len != 0 {
			item := ranges.pop()
			start := item[0]
			end := item[1]
			mut found := false
			for line in mapx {
				ovs := math.max(start, line[1])
				oe := math.min(end, line[1] + line[2])
				if ovs < oe {
					found = true
					sub_ranges << [ovs - line[1] + line[0], oe - line[1] + line[0]]
					if ovs > start {
						ranges << [start, ovs]
					}
					if end > oe {
						ranges << [oe, end]
					}
					break
				}
			}
			if !found {
				sub_ranges << [start, end]
			}
		}
		ranges = sub_ranges.clone()
	}
	smallest := ranges.map(it[0]).sorted()[0]
	println('Part 2: ${smallest}')
}
