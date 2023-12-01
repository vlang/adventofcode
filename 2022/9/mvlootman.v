import os
import math { abs, max }

struct Coord {
mut:
	x int
	y int
}

fn main() {
	lines_part1 := os.read_lines('ropes-part1.input')!
	lines_part2 := os.read_lines('ropes-part2.input')!

	// 2 nodes, 1 HEAD and 1 TAIL
	part1 := solve(lines_part1, 2)
	// 10 nodes, 1 HEAD and 9 TAILS
	part2 := solve(lines_part2, 10)

	println('Part 1:${part1}\nPart 2:${part2}')
}

fn solve(lines []string, number_of_nodes int) int {
	mut visited_positions := []Coord{}
	mut pos_node_list := []Coord{len: number_of_nodes, init: Coord{0, 0}}

	for l in lines {
		parts := l.split(' ')
		dir, distance := parts[0], parts[1].int()

		for _ in 0 .. distance {
			move_head(mut pos_node_list[0], dir)
			// every iteration previous tail becomes the new HEAD to calculate the new tail's position
			for i in 1 .. pos_node_list.len {
				mut head := pos_node_list[i - 1]
				mut tail := pos_node_list[i]

				move_tail(mut tail, head, dir)
				pos_node_list[i] = tail
			}

			if pos_node_list.last() !in visited_positions {
				visited_positions << pos_node_list.last()
			}
		}
	}
	return visited_positions.len
}

fn move_head(mut current_pos_head Coord, dir string) {
	match dir {
		'R' { current_pos_head.move_right() }
		'U' { current_pos_head.move_up() }
		'L' { current_pos_head.move_left() }
		'D' { current_pos_head.move_down() }
		else { panic('unknown direction:${dir}') }
	}
}

fn move_tail(mut current_pos_tail Coord, current_pos_head Coord, dir string) {
	// move TAIL only if 2 steps apart from HEAD
	if current_pos_tail.distance(current_pos_head) >= 2 {
		if current_pos_tail.is_straight(current_pos_head) {
			current_pos_tail.move_straight_to(current_pos_head)
		} else {
			// when H and T are not in the same row or column, T moves diagonally towards H
			current_pos_tail.move_diagonally_to(current_pos_head)
		}
	}
}

fn (mut c Coord) move_right() {
	c.x += 1
}

fn (mut c Coord) move_left() {
	c.x -= 1
}

fn (mut c Coord) move_down() {
	c.y -= 1
}

fn (mut c Coord) move_up() {
	c.y += 1
}

fn (mut c Coord) move_diagonally_to(other Coord) {
	assert c.x != other.x
	if c.x < other.x {
		c.move_right()
	} else {
		c.move_left()
	}

	assert c.y != other.y
	if c.y < other.y {
		c.move_up()
	} else {
		c.move_down()
	}
}

fn (mut c Coord) move_straight_to(other Coord) {
	// x or y coordinate are the same
	// shift the non-equal coordinate
	if c.x == other.x {
		if c.y < other.y {
			c.move_up()
		} else {
			c.move_down()
		}
		return
	}

	if c.x < other.x {
		c.move_right()
	} else {
		c.move_left()
	}
}

fn (c Coord) distance(other Coord) int {
	return max(abs(c.x - other.x), abs(c.y - other.y))
}

fn (c Coord) is_straight(other Coord) bool {
	//  touching if they share row or col
	return c.x == other.x || c.y == other.y
}

fn print_node_list(list []Coord) {
	mut kind := ''
	for i, item in list {
		if i == 0 {
			kind = 'HEAD'
		} else {
			kind = 'TAIL ${i}'
		}
		println('${kind} val:${item}')
	}
}
