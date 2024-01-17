module main

import os

fn main() {
	input_path := 'haunted_wasteland-part1.input'

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

fn (node &Node) is_final() bool {
	return node.name == 'ZZZ'
}

// Builds a network from the list of its nodes described as in the input file
fn build_network(nodes []string) []Node {
	mut network := []Node{}
	for node in nodes {
		network << Node{node.split(' = ')[0], node.split('(')[1].split(',')[0], node.split(', ')[1].split(')')[0]}
	}
	return network
}

fn (network []Node) get_node_by_name(name string) ?Node {
	for node in network {
		if node.name == name {
			return node
		}
	}
	return none
}

// Goes through the whole network using a sequence of directions and returns the number of steps taken
fn traverse_network(network []Node, sequence Sequence) int {
	mut res := 0
	mut current := network.get_node_by_name('AAA') or { panic('Could not find node named "AAA"') }
	for dir in sequence {
		if current.is_final() {
			return res
		} else {
			if dir == 'L' {
				current = network.get_node_by_name(current.left) or {
					panic('Could not find node named ${current.left}')
				}
			} else {
				current = network.get_node_by_name(current.right) or {
					panic('Could not find node named ${current.right}')
				}
			}
			res++
		}
	}
	return res
}
