module main

import os

fn main() {
	input_path := 'pipe_maze-part2.input'

	lines := os.read_lines(input_path) or { panic('Could not read input file.') }
	terrain := build_terrain(lines)
	loop := terrain.get_loop()
	println('Final result: ${terrain.count_inside_loop(loop)}')
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

struct Terrain {
	pipes  [][]string
	width  int
	height int
	animal Coords
}

fn (coords &Coords) str() string {
	return '(${coords.x}, ${coords.y})'
}

fn (terrain &Terrain) str() string {
	mut res := '${terrain.height} x ${terrain.width} terrain with animal at ${terrain.animal} \n'
	for line in terrain.pipes[0..terrain.height - 1] {
		res += line.join(' ') + '\n'
	}
	res += terrain.pipes[terrain.height - 1].join(' ')
	return res
}

fn (coords &Coords) get_north() Coords {
	return Coords{coords.x, coords.y - 1}
}

fn (coords &Coords) get_east() Coords {
	return Coords{coords.x + 1, coords.y}
}

fn (coords &Coords) get_south() Coords {
	return Coords{coords.x, coords.y + 1}
}

fn (coords &Coords) get_west() Coords {
	return Coords{coords.x - 1, coords.y}
}

fn build_terrain(lines []string) Terrain {
	pipes := [][]string{len: lines.len, init: lines[index].split('')}
	width := pipes[0].len
	height := pipes.len
	for x in 0 .. width {
		for y in 0 .. height {
			if pipes[y][x] == 'S' {
				animal := Coords{x, y}
				return Terrain{pipes, width, height, animal}
			}
		}
	}
	return Terrain{pipes, width, height, Coords{-1, -1}}
}

fn (terrain &Terrain) is_valid(position Coords) bool {
	return 0 <= position.x && 0 <= position.y && position.x < terrain.width
		&& position.y < terrain.height
}

fn (terrain &Terrain) get_pipe(position Coords) !string {
	if terrain.is_valid(position) {
		return terrain.pipes[position.y][position.x]
	}
	return error('Position ${position} is not in terrain (of dimension ${terrain.height} x ${terrain.width}).')
}

// Given a position in the terrain, returns the array of connected positions.
// Takes in account the shape of the pipe in this position and the shape of surrounding pipes
fn (terrain &Terrain) get_connected(position Coords) []Coords {
	mut res := []Coords{}
	current_pipe := terrain.get_pipe(position) or { panic(err) }
	if current_pipe in ['S', '|', 'L', 'J'] { // current pipe might be able to connect to north
		if north_pipe := terrain.get_pipe(position.get_north()) {
			if north_pipe in ['S', '|', '7', 'F'] { // north pipe can connect to current pipe
				res << position.get_north()
			}
		}
	}
	if current_pipe in ['S', '-', 'L', 'F'] { // current pipe might be able to connect to east
		if east_pipe := terrain.get_pipe(position.get_east()) {
			if east_pipe in ['S', '-', '7', 'J'] { // east pipe can connect to current pipe
				res << position.get_east()
			}
		}
	}
	if current_pipe in ['S', '|', '7', 'F'] { // current pipe might be able to connect to south
		if south_pipe := terrain.get_pipe(position.get_south()) {
			if south_pipe in ['S', '|', 'L', 'J'] { // south pipe can connect to current pipe
				res << position.get_south()
			}
		}
	}
	if current_pipe in ['S', '-', 'J', '7'] { // current pipe might be able to connect to west
		if west_pipe := terrain.get_pipe(position.get_west()) {
			if west_pipe in ['S', '-', 'L', 'F'] { // west pipe can connect to current pipe
				res << position.get_west()
			}
		}
	}
	return res
}

// Returns the list of all Coords in the loop.
// Element i is next to element i+1 and element 0 is the animal.
fn (terrain &Terrain) get_loop() []Coords {
	// Key idea to go through the loop:
	// Start from the position of the animal and at any point keep in memory two position:
	// - previous: the position where we are comming from
	// - next: the position where we are going
	// At each step, find the connected pipes (there should be 2) and select the one which is different from the one at the previous position.
	// Stop when the position of the animal is reached, meaning we went through the whole loop once.
	mut res := [terrain.animal]
	mut connected := terrain.get_connected(terrain.animal)
	mut previous := connected[0]
	mut next := connected[1]
	for {
		if next == terrain.animal {
			return res
		}
		previous = res[res.len - 1]
		res << next
		connected = terrain.get_connected(next)
		next = if connected[0] != previous { connected[0] } else { connected[1] }
	}
	return res
}

// Returns the number of tiles inside the given loop.
fn (terrain &Terrain) count_inside_loop(loop []Coords) int {
	// For this part we use the shoelace formula, which helps us compute the number of tiles inside the loop, including the loop itself. Then we use Pick's theorem to remove the loop.
	// https://en.wikipedia.org/wiki/Shoelace_formula
	// https://en.wikipedia.org/wiki/Pick%27s_theorem
	mut area := 0
	for i in 0 .. loop.len {
		current := loop[i]
		previous := if i == 0 { loop[loop.len - 1] } else { loop[i - 1] }
		next := if i == loop.len - 1 { loop[0] } else { loop[i + 1] }
		area += current.x * (previous.y - next.y)
	}
	return area / 2 - loop.len / 2 + 1
}
