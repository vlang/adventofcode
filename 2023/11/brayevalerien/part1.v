module main

import os
import math

fn main() {
	input_path := 'stargazing.input'

	lines := os.read_lines(input_path) or { panic('Could not read input file.') }
	mut cosmos := Cosmos.new(lines)
	cosmos.expand()
	cosmos.locate_galaxies()
	println('Final result: ${cosmos.sum_of_distances()}')
}

// 0 -----> x
// |
// |
// v
// y
struct Coords {
	x int
	y int
}

struct Cosmos {
mut:
	field    [][]string
	galaxies []Coords
}

fn (coords &Coords) str() string {
	return '(${coords.x}, ${coords.y})'
}

fn Cosmos.new(lines []string) Cosmos {
	mut field := [][]string{}
	for line in lines {
		field << line.split('')
	}
	return Cosmos{field, []Coords{}}
}

fn (cosmos Cosmos) str() string {
	mut res := ''
	for line in cosmos.field[0..cosmos.field.len - 1] {
		res += line.join('') + '\n'
	}
	res += cosmos.field[cosmos.field.len - 1].join('')
	return res
}

// Doubles the lines and columns of cosmos.field where there is no galaxy.
fn (mut cosmos Cosmos) expand() {
	// Idea:
	// 1. expand lines
	// 2. transpose
	// 3. expand lines (old columns)
	// 4. transpose again
	cosmos.field = transpose_field(expand_field_lines(transpose_field(expand_field_lines(cosmos.field))))
}

fn expand_field_lines(field [][]string) [][]string {
	mut res := [][]string{}
	for line in field {
		res << line
		if '#' !in line { // no galaxy in line, add it twice
			res << line
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
fn (cosmos Cosmos) sum_of_distances() int {
	mut res := 0
	// 1. Construct the array of pairs of galaxies
	// 2. For each pair, compute the Manhattan distance and add it to the result
	for i in 0 .. cosmos.galaxies.len - 1 {
		for j in (i + 1) .. cosmos.galaxies.len {
			res += dist_manhattan(cosmos.galaxies[i], cosmos.galaxies[j])
		}
	}
	return res
}

fn dist_manhattan(pos1 Coords, pos2 Coords) int {
	return math.abs(pos2.x - pos1.x) + math.abs(pos2.y - pos1.y)
}
