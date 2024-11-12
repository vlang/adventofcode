module main

import regex
import os
import datatypes
import arrays

struct Valve {
	node        string
	rate        int
	connections []string
mut:
	possible_nodes map[string]int
}

const max_time = 30

fn main() {
	node_map := parse_input('valves.input') or { panic(err) }
	part1 := traverse(node_map, 'AA', []string{}, 0)
	println(part1)
	// part 1 only!
}

fn parse_input(file string) !map[string]Valve {
	input_pattern := r'Valve (\w+) has flow rate=(\d+); tunnels? leads? to valves? (.*)'
	re := regex.regex_opt(input_pattern) or { panic(err) }
	valves := os.read_lines(file)!
		.map(parse_valve(it, re))

	mut node_map := map[string]Valve{}
	// create lookup node_map
	for valve in valves {
		node_map[valve.node] = valve
	}

	// create map with all possible locations per node
	for k, _ in node_map {
		node_map[k].possible_nodes = cost_map(k, node_map)!
	}

	return node_map
}

fn parse_valve(line string, re regex.RE) Valve {
	re.match_string(line)
	matches := re.get_group_list()
		.map(line[it.start..it.end])

	return Valve{
		node:        matches[0]
		rate:        matches[1].int()
		connections: matches[2].split(',').map(it.trim_space())
	}
}

fn traverse(node_map map[string]Valve, current_node string, visited []string, time int) int {
	if time >= max_time {
		return 0
	}

	node := node_map[current_node]
	score := node.rate * (max_time - time)
	new_visited := arrays.concat(visited, current_node)
	mut max_child_score := 0
	for neighbour, _ in node.possible_nodes {
		if neighbour !in visited {
			child_score := traverse(node_map, neighbour, new_visited, time +
				node.possible_nodes[neighbour] + 1)
			if child_score > max_child_score {
				max_child_score = child_score
			}
		}
	}
	return score + max_child_score
}

fn cost_map(start_node string, lookup map[string]Valve) !map[string]int {
	// BFS to calculate the amount of steps needed to reach each node
	mut queue := datatypes.Queue[string]{}
	mut cost_map := map[string]int{}

	queue.push(start_node)
	for queue.len() > 0 {
		curr := queue.pop()!
		for adj in lookup[curr].connections {
			if adj !in cost_map {
				cost_map[adj] = cost_map[curr] + 1
				queue.push(adj)
			}
		}
		// step to itself is unnecessary (optimize running)
		cost_map.delete(start_node)
	}

	// optimize remove locations with flow rate 0
	zero_rate_locations := lookup.values().filter(it.rate == 0)
	for zero_location in zero_rate_locations {
		cost_map.delete(zero_location.node)
	}
	return cost_map
}
