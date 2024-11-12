module main

import os
import math

struct Node {
	left  string
	right string
}

fn main() {
	println('Part 1: ${solver('haunted_wasteland-part1.input', false)!}')
	println('Part 2: ${solver('haunted_wasteland-part2.input', true)!}')
}

fn solver(filename string, part_2 bool) !i64 {
	directions, nodes := os.read_file(filename)!.split_once('\n\n') or {
		return error('Failed to derive nodes from "${filename}"')
	}
	node_lines := nodes.split_into_lines()
	mut node_map := map[string]Node{}
	mut working_nodes := []string{}
	for node in node_lines {
		split_up := node.split(' = ') // 0 => node name
		coord := split_up[1].split_any('(,)').filter(it != '').map(it.trim_space()) // 0 => left, 1 => right
		node_map[split_up[0]] = Node{
			left:  coord[0]
			right: coord[1]
		}
		if split_up[0][split_up[0].len - 1] == `A` && part_2 {
			working_nodes << split_up[0]
		}
	}
	mut loop_counts := []int{}
	if !part_2 {
		working_nodes << 'AAA'
	}
	for node in working_nodes {
		mut dir_index := 0
		mut loop_iterations := 0
		mut curr_node := node
		for curr_node[curr_node.len - 1] != `Z` {
			match directions[dir_index] {
				`L` {
					curr_node = node_map[curr_node].left
				}
				`R` {
					curr_node = node_map[curr_node].right
				}
				else {}
			}
			if dir_index == directions.len - 1 {
				dir_index = 0
			} else {
				dir_index++
			}
			loop_iterations++
		}
		loop_counts << loop_iterations
	}
	mut lcm := i64(loop_counts[0])
	for i := 1; i < loop_counts.len; i++ {
		lcm = math.lcm(lcm, loop_counts[i])
	}
	return lcm
}
