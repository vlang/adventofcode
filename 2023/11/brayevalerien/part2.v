module main

import os
import math

fn main() {
	input_path := '../stargazing.input'

	lines := os.read_lines(input_path) or { panic('Could not read input file.') }
	mut cosmos := Cosmos.new(lines)
	expansion_factor := 1000000 // number of times the empty lines and columns are duplicated
	cosmos.expand(expansion_factor)
	println(cosmos)
	cosmos.locate_galaxies()
	println('Final result: ${cosmos.sum_of_distances()}')
}

// 0 -----> x
// |
// |
// v
// y
struct Coords {
	x i64
	y i64
}

struct Cosmos {
mut:
	field            [][]string
	galaxies         []Coords
	expanded_lines   []i64
	expanded_columns []i64
	expansion_factor i64
}

fn (coords &Coords) str() string {
	return '(${coords.x}, ${coords.y})'
}

fn Cosmos.new(lines []string) Cosmos {
	mut field := [][]string{}
	for line in lines {
		field << line.split('')
	}
	return Cosmos{field, []Coords{}, []i64{}, []i64{}, 1}
}

fn (cosmos Cosmos) str() string {
	mut res := 'expanded lines: ${cosmos.expanded_lines}   |   expanded columns: ${cosmos.expanded_columns}\n'
	for line in cosmos.field[0..cosmos.field.len - 1] {
		res += line.join('') + '\n'
	}
	res += cosmos.field[cosmos.field.len - 1].join('')
	return res
}

// Doubles the lines and columns of cosmos.field where there is no galaxy.
fn (mut cosmos Cosmos) expand(factor i64) {
	// Idea:
	// 1. store expanded lines in cosmos.expanded_lines
	// 2. transpose
	// 3. store expand lines (old columns) in cosmos.expanded_columns
	// 4. transpose again
	cosmos.expanded_lines = expand_field_lines(cosmos.field)
	transposed_field := transpose_field(cosmos.field)
	cosmos.expanded_columns = expand_field_lines(transposed_field)
	cosmos.expansion_factor = factor
}

fn expand_field_lines(field [][]string) []i64 {
	mut res := []i64{}
	for i, line in field {
		if '#' !in line { // no galaxy in line, add it twice
			res << i
		}
	}
	return res
}

// Given a field, returns the same field but where lines and columns have been swapped.
fn transpose_field(field [][]string) [][]string {
	mut res := [][]string{len: field[0].len, init: []string{len: field.len}}
	for y in 0 .. field.len {
		for x in 0 .. field[y].len {
			res[x][y] = field[y][x]
		}
	}
	return res
}

// Fills the 'galaxies' field of cosmos with the coordinates of the galaxies ('#') in cosmos.field.
fn (mut cosmos Cosmos) locate_galaxies() {
	mut galaxies := []Coords{}
	for y, line in cosmos.field {
		for x, object in line {
			if object == '#' {
				galaxies << Coords{x, y}
			}
		}
	}
	cosmos.galaxies = galaxies
}

// Finds the sum of all distances between pairs of galaxies (each pair is used only once).
fn (cosmos Cosmos) sum_of_distances() i64 {
	mut res := i64(0)
	// 1. Construct the array of pairs of galaxies
	// 2. For each pair, compute the Manhattan distance and add it to the result
	for i in 0 .. cosmos.galaxies.len - 1 {
		for j in (i + 1) .. cosmos.galaxies.len {
			res += cosmos.dist_manhattan(cosmos.galaxies[i], cosmos.galaxies[j])
		}
	}
	return res
}

fn (cosmos Cosmos) dist_manhattan(pos1 Coords, pos2 Coords) i64 {
	return cosmos.dx(pos1, pos2) + cosmos.dy(pos1, pos2)
}

fn (cosmos Cosmos) dx(pos1 Coords, pos2 Coords) i64 {
	min_x := math.min(pos1.x, pos2.x)
	max_x := math.max(pos1.x, pos2.x)
	mut res := i64(0)
	for x in min_x .. max_x {
		if x in cosmos.expanded_columns {
			res += cosmos.expansion_factor
		} else {
			res += 1
		}
	}
	return res
}

fn (cosmos Cosmos) dy(pos1 Coords, pos2 Coords) i64 {
	min_y := math.min(pos1.y, pos2.y)
	max_y := math.max(pos1.y, pos2.y)
	mut res := i64(0)
	for y in min_y .. max_y {
		if y in cosmos.expanded_lines {
			res += cosmos.expansion_factor
		} else {
			res += 1
		}
	}
	return res
}
