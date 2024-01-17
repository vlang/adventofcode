module main

import os
import math

fn main() {
	input_path := 'haunted_wasteland-part2.input'

	lines := os.read_lines(input_path) or { panic('Could not read input file.') }
	sequence := Sequence{lines[0].split(''), 0}
	network := build_network(lines[2..])
	res := traverse_network(network, sequence)
	println('Final result: ${res}')
}

// Sequence of instructions, looped
struct Sequence {
	arr []string // array of 'L' and 'R'
mut:
	idx int
}

fn (mut iter Sequence) next() ?string {
	if iter.arr.len <= iter.idx {
		iter.idx = 0
	}
	defer {
		iter.idx++
	}
	return iter.arr[iter.idx]
}

struct Node {
	name  string
	left  string
	right string
}

fn (node &Node) str() string {
	return '${node.name}: (${node.left}, ${node.right})'
}

fn (node &Node) is_start() bool {
	return node.name.ends_with('A')
}

fn (node &Node) is_final() bool {
	return node.name.ends_with('Z')
}

// Builds a network from the list of its nodes described as in the input file
fn build_network(nodes []string) []Node {
	mut network := []Node{}
	for node in nodes {
		network << Node{node.split(' = ')[0], node.split('(')[1].split(',')[0], node.split(', ')[1].split(')')[0]}
	}
	return network
}

// Returns all starting nodes of the network, i.e. nodes with a name ending with 'A'
fn (network []Node) get_start_nodes() []Node {
	mut start_nodes := []Node{}
	for node in network {
		if node.is_start() {
			start_nodes << node
		}
	}
	return start_nodes
}

fn (network []Node) get_node_by_name(name string) ?Node {
	for node in network {
		if node.name == name {
			return node
		}
	}
	return none
}

// Given a current node and a direction, takes a step into the direction, from the current node
// in the network and returns the resulting node.
fn (network []Node) step(node Node, dir string) Node {
	if dir == 'L' {
		return network.get_node_by_name(node.left) or {
			panic('Could not find node named ${node.left}')
		}
	} else {
		return network.get_node_by_name(node.right) or {
			panic('Could not find node named ${node.right}')
		}
	}
}

fn all_final(nodes []Node) bool {
	for node in nodes {
		if !node.is_final() {
			return false
		}
	}
	return true
}

fn array_lcm(nums []int) i64 {
	mut res := i64(1)
	for n in nums {
		res = math.lcm(res, n)
	}
	return res
}

// Goes through the whole network using a sequence of directions and returns the number of steps taken
fn traverse_network(network []Node, sequence Sequence) i64 {
	mut paths := network.get_start_nodes()
	mut lengths := []int{len: paths.len}
	for i in 0 .. paths.len {
		mut length := 0
		for dir in sequence {
			if paths[i].is_final() {
				lengths[i] = length
				break
			}
			paths[i] = network.step(paths[i], dir)
			length++
		}
	}
	return array_lcm(lengths)
}
