module main

import os
import datatypes

struct Coordinate {
	x    int
	y    int
	dist int
}

fn (c Coordinate) str() string {
	return '${c.x},${c.y}'
}

struct HillMap {
	grid   [][]rune
	height int
	width  int
mut:
	start_pos Coordinate
	end_pos   Coordinate
}

fn main() {
	lines := os.read_lines('hills.input')!
	mut hill_map := new(lines)
	part1 := hill_map.solve(true)

	// part 2 backtrack from E to the first `a`
	// swap start end positions
	hill_map.start_pos, hill_map.end_pos = hill_map.end_pos, hill_map.start_pos
	part2 := hill_map.solve(false)

	println('Part 1: ${part1}\nPart 2: ${part2}')
}

fn new(lines []string) HillMap {
	width, height := lines.first().len, lines.len

	mut grid := [][]rune{len: height, init: []rune{len: width}}
	for idx, l in lines {
		grid[idx] = l.runes()
	}
	start_pos := find_location(grid, `S`)
	grid[start_pos.y][start_pos.x] = `a` // start S -> elevation `a`

	end_pos := find_location(grid, `E`)
	grid[end_pos.y][end_pos.x] = `z` // end E -> elevation `z`

	hill_map := HillMap{
		width:     width
		height:    height
		grid:      grid
		start_pos: start_pos
		end_pos:   end_pos
	}

	return hill_map
}

fn (h HillMap) solve(part1 bool) int {
	pos := h.start_pos
	path_len := h.visit_adjacent(pos.x, pos.y, part1)
	return path_len
}

fn (h HillMap) visit_adjacent(x int, y int, part1 bool) int {
	mut stack := datatypes.Queue[Coordinate]{}
	mut seen := map[string]bool{}

	stack.push(Coordinate{
		dist: 0
		x:    h.start_pos.x
		y:    h.start_pos.y
	})

	for {
		curr := stack.pop() or { panic(err) }
		if curr.str() in seen {
			continue
		}
		seen[curr.str()] = true

		if part1 {
			if h.end_pos.x == curr.x && h.end_pos.y == curr.y {
				// Found end location
				return curr.dist
			}
		} else {
			if h.grid[curr.y][curr.x] == `a` {
				// Found `a` location
				return curr.dist
			}
		}
		for n in h.neighbours(curr.x, curr.y, part1) {
			stack.push(Coordinate{ dist: curr.dist + 1, x: n.x, y: n.y })
		}
	}
	return -1 // no solution was found
}

// neighbours are the cells around current position which
// are allowed to be visited (e.g. not off-board, or too high to climb)
fn (h HillMap) neighbours(x int, y int, part1 bool) []Coordinate {
	mut neighbours := []Coordinate{}

	for position in [[0, 1], [1, 0], [0, -1], [-1, 0]] { // down/right/up/left
		dx, dy := position[0], position[1]
		new_x := x + dx
		new_y := y + dy

		if part1 {
			// must not be out-of-bounds or more than 1 higher elevation
			if new_x >= 0 && new_x < h.width && new_y >= 0 && new_y < h.height
				&& h.grid[y][x] + 1 >= h.grid[new_y][new_x] {
				neighbours << Coordinate{
					x: new_x
					y: new_y
				}
			}
		} else {
			// must not be out-of-bounds and can only be 1 lower elevation (backtracking)
			if new_x >= 0 && new_x < h.width && new_y >= 0 && new_y < h.height
				&& h.grid[new_y][new_x] >= h.grid[y][x] - 1 {
				neighbours << Coordinate{
					x: new_x
					y: new_y
				}
			}
		}
	}
	return neighbours
}

fn find_location(grid [][]rune, target rune) Coordinate {
	for r_id, row in grid {
		for c_id, col in row {
			if col == target {
				return Coordinate{
					x: c_id
					y: r_id
				}
			}
		}
	}
	panic('target ${target} was not found in grid}')
}
