import datatypes { Set }
import os

struct Position {
mut:
	x int
	y int
}

fn (pos Position) encode() string {
	return '${pos.x},${pos.y}'
}

fn Position.decode(encoded string) Position {
	parts := encoded.split(',')
	return Position{
		x: parts[0].int()
		y: parts[1].int()
	}
}

enum Side {
	top
	right
	bottom
	left
}

fn (side Side) encode() string {
	return match side {
		.top { 'top' }
		.right { 'right' }
		.bottom { 'bottom' }
		.left { 'left' }
	}
}

fn Side.decode(encoded string) Side {
	return match encoded {
		'top' { .top }
		'right' { .right }
		'bottom' { .bottom }
		'left' { .left }
		else { panic('Invalid side') }
	}
}

struct Face {
	position Position
	side     Side
}

fn (face Face) encode() string {
	return '${face.position.encode()}-${face.side.encode()}'
}

fn Face.decode(encoded string) Face {
	parts := encoded.split('-')
	return Face{
		position: Position.decode(parts[0])
		side:     Side.decode(parts[1])
	}
}

struct Plot {
mut:
	positions Set[string]
	faces     Set[string]
	char      rune
}

fn (mut plot Plot) area() int {
	return plot.positions.size()
}

fn (mut plot Plot) perimeter() int {
	return plot.faces.size()
}

struct Direction {
	pos      Position
	side     Side
	opposite Side
}

fn (mut plot Plot) sides() int {
	mut used_faces := Set[string]{}
	mut sides := 0

	mut face_copy := plot.faces.copy()
	for face_copy.size() > 0 {
		face_key := face_copy.pop() or { panic('No face found') }
		if used_faces.exists(face_key) {
			continue
		}

		current_face := Face.decode(face_key)
		mut found_faces := Set[string]{}
		if current_face.side == .left || current_face.side == .right {
			// Try moving down from the initial position
			mut down_cf := current_face
			for plot.faces.exists(down_cf.encode()) {
				found_faces.add(down_cf.encode())
				down_cf = Face{
					position: Position{down_cf.position.x, down_cf.position.y + 1}
					side:     down_cf.side
				}
			}

			// Try moving up from the initial position
			mut up_cf := current_face
			for plot.faces.exists(up_cf.encode()) {
				found_faces.add(up_cf.encode())
				up_cf = Face{
					position: Position{up_cf.position.x, up_cf.position.y - 1}
					side:     up_cf.side
				}
			}
		} else {
			// Try moving right from the initial position
			mut right_cf := current_face
			for plot.faces.exists(right_cf.encode()) {
				found_faces.add(right_cf.encode())
				right_cf = Face{
					position: Position{right_cf.position.x + 1, right_cf.position.y}
					side:     right_cf.side
				}
			}

			// Try moving left from the initial position
			mut left_cf := current_face
			for plot.faces.exists(left_cf.encode()) {
				found_faces.add(left_cf.encode())
				left_cf = Face{
					position: Position{left_cf.position.x - 1, left_cf.position.y}
					side:     left_cf.side
				}
			}
		}

		// Add all found faces to used_faces
		for found_faces.size() > 0 {
			used_faces.add(found_faces.pop() or { panic('No face found') })
		}
		sides++
	}
	return sides
}

fn get_plot(garden [][]rune, start Position) Plot {
	start_char := garden[start.y][start.x]
	mut plot := Plot{
		positions: Set[string]{}
		faces:     Set[string]{}
		char:      start_char
	}

	plot.positions.add(start.encode())

	plot.faces.add_all([
		Face{start, .top}.encode(),
		Face{start, .right}.encode(),
		Face{start, .bottom}.encode(),
		Face{start, .left}.encode(),
	])

	mut visited := [][]bool{len: garden.len, init: []bool{len: garden[0].len, init: false}}
	mut to_process := [start]

	for i := 0; i < to_process.len; i++ {
		pos := to_process[i]
		if visited[pos.y][pos.x] {
			continue
		}

		visited[pos.y][pos.x] = true
		directions := [
			Direction{Position{pos.x - 1, pos.y}, .left, .right},
			Direction{Position{pos.x + 1, pos.y}, .right, .left},
			Direction{Position{pos.x, pos.y - 1}, .top, .bottom},
			Direction{Position{pos.x, pos.y + 1}, .bottom, .top},
		]

		for dir in directions {
			new_pos := dir.pos
			new_side := dir.side
			opposite_side := dir.opposite

			if new_pos.x >= 0 && new_pos.x < garden[0].len && new_pos.y >= 0
				&& new_pos.y < garden.len && garden[new_pos.y][new_pos.x] == start_char
				&& !visited[new_pos.y][new_pos.x] {
				plot.positions.add(new_pos.encode())
				to_process << new_pos

				plot.faces.remove(Face{pos, new_side}.encode())
				plot.faces.remove(Face{new_pos, opposite_side}.encode())

				// Add new faces if needed
				if !plot.positions.exists(Position{new_pos.x, new_pos.y - 1}.encode()) {
					plot.faces.add(Face{new_pos, .top}.encode())
				}
				if !plot.positions.exists(Position{new_pos.x + 1, new_pos.y}.encode()) {
					plot.faces.add(Face{new_pos, .right}.encode())
				}
				if !plot.positions.exists(Position{new_pos.x, new_pos.y + 1}.encode()) {
					plot.faces.add(Face{new_pos, .bottom}.encode())
				}
				if !plot.positions.exists(Position{new_pos.x - 1, new_pos.y}.encode()) {
					plot.faces.add(Face{new_pos, .left}.encode())
				}
			}
		}
	}
	return plot
}

fn main() {
	input := os.read_file('garden.input')!
	garden := input.split_into_lines().map(it.runes())
	mut plots := []Plot{}
	mut garden_copy := garden.clone()

	// Find all plots
	for {
		mut found := false
		mut start := Position{0, 0}
		for y := 0; y < garden_copy.len; y++ {
			for x := 0; x < garden_copy[0].len; x++ {
				if garden_copy[y][x] != `.` {
					start = Position{x, y}
					found = true
					break
				}
			}
			if found {
				break
			}
		}
		if !found {
			break
		}

		plot := get_plot(garden_copy, start)
		mut positions_copy := plot.positions.copy()
		for positions_copy.size() > 0 {
			pos := Position.decode(positions_copy.pop()!)
			garden_copy[pos.y][pos.x] = `.`
		}
		plots << plot
	}

	mut part1 := 0
	for mut plot in plots {
		part1 += plot.area() * plot.perimeter()
	}
	println('part1: ${part1}')

	mut part2 := 0
	for mut plot in plots {
		part2 += plot.area() * plot.sides()
	}
	println('part2: ${part2}')
}
