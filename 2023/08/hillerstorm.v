module main

import os
import math

const lr_directions = {
	`L`: 0
	`R`: 1
}

fn main() {
	part_one := solve_day_eight(os.read_file('haunted_wasteland-part1.input')!.split('\n\n'),
		false)
	part_two := solve_day_eight(os.read_file('haunted_wasteland-part2.input')!.split('\n\n'),
		true)

	println('Part 1: ${part_one}')
	println('Part 2: ${part_two}')
}

fn solve_day_eight(parts []string, part_two bool) i64 {
	instructions := parts[0].runes().map(lr_directions[it])
	node_list := parts[1].split_into_lines()
		.map(it.split_any(' =(,)').map(it.trim_space()).filter(it != ''))

	mut nodes := map[string][]string{}
	for node in node_list {
		nodes[node[0]] = node[1..]
	}

	if !part_two {
		return find_path_length('AAA', nodes, instructions)
	}

	mut result := i64(0)
	mut starts := node_list.filter(it[0][2] == `A`).map(it[0])
	for start in starts {
		path_len := find_path_length(start, nodes, instructions)

		if result == 0 {
			result = path_len
		} else {
			result = math.lcm(result, i64(path_len))
		}
	}

	return result
}

fn find_path_length(start string, nodes map[string][]string, instructions []int) int {
	mut current := start
	mut path_length := 0
	outer: for {
		for instruction in instructions {
			current = nodes[current][instruction]
			path_length += 1

			if current[2] == `Z` {
				break outer
			}
		}
	}

	return path_length
}
