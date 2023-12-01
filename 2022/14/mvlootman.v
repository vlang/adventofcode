module main

import math
import arrays { max }
import os

const air = `.`
const rock = `#`
const sand = `o`
const drop_location = `+`

const a = 2

fn main() {
	paths := os.read_lines('cave.input')!
		.map(it.split(' -> '))
		.map(parse_coord(it))

	mut sim := Simulation{}
	sim.add_paths(paths)
	part1 := sim.run_part1()

	sim.reset()
	sim.add_paths(paths)
	sim.set_floor(2)
	part2 := sim.run_part2()
	println('Part1: ${part1}\nPart2: ${part2}')
}

fn parse_coord(path []string) []Coord {
	return path.map(it.split(',')
		.map(it.int()))
		.map(Coord{it[0], it[1]})
}

struct Coord {
mut:
	x int
	y int
}

// str converts coord into string (so it can be used as a map key)
fn (c Coord) str() string {
	return '${c.x},${c.y}'
}

struct Simulation {
mut:
	occupied          map[string]rune
	lowest_rock_level int
}

fn (mut s Simulation) drop_sand_part1() string {
	// location of sand source
	mut x, mut y := 500, 0

	for y < s.lowest_rock_level {
		// try and fall down straight
		if '${x},${y + 1}' !in s.occupied {
			y++
			continue
		}
		// try and fall down/left
		if '${x - 1},${y + 1}' !in s.occupied {
			x--
			y++
			continue
		}
		// try and fall down/right
		if '${x + 1},${y + 1}' !in s.occupied {
			x++
			y++
			continue
		}
		// no place to go
		s.occupied['${x},${y}'] = sand
		return '${x},${y}'
	}
	return '' // sand dropped into abyss
}

fn (mut s Simulation) drop_sand_part2() string {
	mut x, mut y := 500, 0 // location of sand source

	for y < s.lowest_rock_level {
		// try and fall down straight
		if '${x},${y + 1}' !in s.occupied {
			y++
			continue
		}
		// try and fall down/left
		if '${x - 1},${y + 1}' !in s.occupied {
			x--
			y++
			continue
		}
		// try and fall down/right
		if '${x + 1},${y + 1}' !in s.occupied {
			x++
			y++
			continue
		}
		// sand has settled
		s.occupied['${x},${y}'] = sand
		return '${x},${y}' // resting location of sand
	}
	s.occupied['${x},${y}'] = rock // infinite floor
	return '${x},${y}'
}

fn (mut s Simulation) run_part1() int {
	mut sand_count := 0

	for true {
		loc := s.drop_sand_part1()
		if loc.len > 0 {
			sand_count++
		} else {
			break
		}
	}
	return sand_count
}

fn (mut s Simulation) run_part2() int {
	mut sand_count := 0

	for true {
		loc := s.drop_sand_part2()
		sand_count++
		if loc == '500,0' {
			break
		}
	}
	return sand_count
}

fn (mut s Simulation) reset() {
	s.occupied = map[string]rune{} //.clear()
	s.lowest_rock_level = 0
}

fn (mut s Simulation) add_paths(paths [][]Coord) {
	for path in paths {
		// iterate all intermediate points
		for idx in 1 .. path.len {
			from := path[idx - 1]
			to := path[idx]
			if from.x == to.x {
				for dy in math.min(from.y, to.y) .. math.max(from.y, to.y) + 1 {
					s.occupied['${from.x},${dy}'] = rock
				}
			} else if from.y == to.y {
				for dx in math.min(from.x, to.x) .. math.max(from.x, to.x) + 1 {
					s.occupied['${dx},${from.y}'] = rock
				}
			}
		}
	}
	s.lowest_rock_level = max(s.occupied.keys().map(it.split(',')[1].int())) or { -1 }
}

fn (mut s Simulation) set_floor(by_units int) {
	s.lowest_rock_level += by_units - 1
}
