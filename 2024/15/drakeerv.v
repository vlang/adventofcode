import os
import arrays

enum Tile {
	wall
	box1
	box2
	empty
}

struct Vector {
pub:
	// Change to immutable
	x int
	y int
}

fn (v Vector) update(other Vector) Vector {
	return Vector{other.x, other.y}
}

fn (v Vector) add(other Vector) Vector {
	return Vector{v.x + other.x, v.y + other.y}
}

fn (v Vector) sub(other Vector) Vector {
	return Vector{v.x - other.x, v.y - other.y}
}

fn (v Vector) mul(other Vector) Vector {
	return Vector{v.x * other.x, v.y * other.y}
}

fn (v Vector) eq(other Vector) bool {
	return v.x == other.x && v.y == other.y
}

fn (v Vector) clone() Vector {
	return Vector{v.x, v.y}
}

fn get_tile(grid [][]Tile, position Vector) Tile {
	return grid[position.y][position.x]
}

fn set_tile(mut grid [][]Tile, position Vector, tile Tile) {
	grid[position.y][position.x] = tile
}

fn parse_map_tile(c string) Tile {
	return match c {
		'#' { Tile.wall }
		'O' { Tile.box1 }
		'.' { Tile.empty }
		'@' { Tile.empty }
		else { panic('Invalid tile character: ${c}') }
	}
}

fn parse_movement(c string) Vector {
	return match c {
		'v' { Vector{0, 1} }
		'^' { Vector{0, -1} }
		'<' { Vector{-1, 0} }
		'>' { Vector{1, 0} }
		else { panic('Invalid movement character: ${c}') }
	}
}

fn find_both_boxes(grid [][]Tile, position Vector) []Vector {
	tile := get_tile(grid, position)
	if tile == .box1 {
		mut box2_pos := position.clone()
		box2_pos = box2_pos.add(Vector{1, 0})
		return [position, box2_pos]
	} else if tile == .box2 {
		mut box1_pos := position.clone()
		box1_pos = box1_pos.add(Vector{-1, 0})
		return [box1_pos, position]
	}
	panic('Invalid box position')
}

fn is_movable_y(grid [][]Tile, position Vector, movement Vector) bool {
	tile := get_tile(grid, position)
	if tile == .wall {
		return false
	} else if tile == .empty {
		return true
	}

	// Find both boxes and check if they can move
	boxes := find_both_boxes(grid, position)
	mut next_box1_pos := boxes[0].clone()
	mut next_box2_pos := boxes[1].clone()
	next_box1_pos = next_box1_pos.add(movement)
	next_box2_pos = next_box2_pos.add(movement)

	return is_movable_y(grid, next_box1_pos, movement)
		&& is_movable_y(grid, next_box2_pos, movement)
}

fn move_box_y(mut grid [][]Tile, box1_pos Vector, movement Vector) {
	next_left_pos := box1_pos.add(movement)
	next_right_pos := next_left_pos.add(Vector{1, 0})
	next_left_tile := get_tile(grid, next_left_pos)
	next_right_tile := get_tile(grid, next_right_pos)

	if next_left_tile == .box1 {
		move_box_y(mut grid, next_left_pos, movement)
	} else if next_left_tile == .box2 {
		move_box_y(mut grid, next_left_pos.add(Vector{-1, 0}), movement)
	}

	if next_right_tile == .box1 {
		move_box_y(mut grid, next_right_pos, movement)
	}

	set_tile(mut grid, next_left_pos, .box1)
	set_tile(mut grid, next_right_pos, .box2)
	set_tile(mut grid, box1_pos, .empty)
	set_tile(mut grid, box1_pos.add(Vector{1, 0}), .empty)
}

fn is_movable_x(grid [][]Tile, position Vector, movement Vector) ?Vector {
	tile := get_tile(grid, position)
	if tile == .wall {
		return none
	} else if tile == .empty {
		return position
	}

	if tile == .box1 {
		return is_movable_x(grid, position.add(Vector{2, 0}), movement)
	} else if tile == .box2 {
		return is_movable_x(grid, position.add(Vector{-2, 0}), movement)
	}
	return none
}

fn main() {
	data := os.read_file('movements.input')!.replace('\r', '').split('\n')
	separation := data.index('')

	// Parse the grid
	mut grid := [][]Tile{}
	for row in data[..separation] {
		grid << row.split('').map(parse_map_tile)
	}

	// Find robot position
	mut robot := Vector{0, 0}
	for y, row in data[..separation] {
		x := row.index('@') or { continue }
		robot = Vector{int(x), y}
		break
	}

	// Parse movements
	movements := data[separation + 1..].filter(it != '').join('').split('').map(parse_movement)

	// PART 1
	mut robot1 := robot.clone()
	mut grid1 := [][]Tile{len: grid.len, init: grid[index].clone()}

	// Execute movements
	for movement in movements {
		mut next_robot_position := robot1.clone()
		next_robot_position = next_robot_position.add(movement)
		next_robot_tile := get_tile(grid1, next_robot_position)

		if next_robot_tile == .wall {
			continue
		}

		if next_robot_tile == .box1 {
			mut next_box_position := next_robot_position.clone()
			next_box_position = next_box_position.add(movement)
			mut next_box_tile := get_tile(grid1, next_box_position)

			for next_box_tile == .box1 {
				next_box_position = next_box_position.add(movement)
				next_box_tile = get_tile(grid1, next_box_position)
			}

			if next_box_tile == .wall {
				continue
			}

			set_tile(mut grid1, next_box_position, .box1)
			set_tile(mut grid1, next_robot_position, .empty)
		}

		robot1 = robot1.update(next_robot_position)
	}

	// Calculate part 1
	mut part1 := 0
	for y, row in grid1 {
		for x, tile in row {
			if tile == .box1 {
				part1 += (y * 100) + x
			}
		}
	}
	println('part1: ${part1}')

	// PART 2
	mut robot2 := robot.clone()
	robot2 = robot2.mul(Vector{2, 1})

	mut grid2 := [][]Tile{}
	for row in grid {
		mut row_tiles := [][]Tile{}
		for tile in row {
			if tile == .box1 {
				row_tiles << [Tile.box1, Tile.box2]
			} else {
				row_tiles << [tile, tile]
			}
		}
		grid2 << arrays.flatten[Tile](row_tiles)
	}

	// Execute movements for part 2
	for movement in movements {
		next_robot_position := robot2.add(movement)
		next_robot_tile := get_tile(grid2, next_robot_position)

		if next_robot_tile == .wall {
			continue
		}

		if next_robot_tile in [.box1, .box2] {
			if movement.x == 0 {
				// Vertical movement logic
				if !is_movable_y(grid2, next_robot_position, movement) {
					continue
				}
				boxes := find_both_boxes(grid2, next_robot_position)
				move_box_y(mut grid2, boxes[0], movement)
			} else {
				// Horizontal movement logic
				next_box_pos := is_movable_x(grid2, next_robot_position, movement) or { continue }

				mut next_box_move_pos := next_box_pos
				mut next_box_tile := get_tile(grid2, next_box_move_pos.sub(movement))
				set_tile(mut grid2, next_box_pos, next_box_tile)

				for next_box_tile != .empty {
					next_box_move_pos = next_box_move_pos.sub(movement)
					next_box_tile = get_tile(grid2, next_box_move_pos.sub(movement))
					set_tile(mut grid2, next_box_move_pos, next_box_tile)
				}
			}
		}

		robot2 = robot2.update(next_robot_position)
	}

	// Calculate part 2
	mut part2 := 0
	for y, row in grid2 {
		for x, tile in row {
			if tile == .box1 {
				part2 += (y * 100) + x
			}
		}
	}
	println('part2: ${part2}')
}
