import os { read_file }
import math { abs, sign }

struct Position {
	x int
	y int
}

fn (p &Position) offset_x(x int) Position {
	return p.offset(x, 0)
}

fn (p &Position) offset_y(y int) Position {
	return p.offset(0, y)
}

fn (p &Position) offset(x int, y int) Position {
	return Position{
		x: p.x + x
		y: p.y + y
	}
}

fn (p &Position) move_head(direction u8) Position {
	return match direction.ascii_str() {
		'U' {
			p.offset_y(1)
		}
		'D' {
			p.offset_y(-1)
		}
		'L' {
			p.offset_x(-1)
		}
		'R' {
			p.offset_x(1)
		}
		else {
			*p
		}
	}
}

fn (p &Position) follow_head(head &Position) Position {
	return if head.x == p.x && abs(head.y - p.y) > 1 {
		p.offset_y(int(sign(head.y - p.y)))
	} else if head.y == p.y && abs(head.x - p.x) > 1 {
		p.offset_x(int(sign(head.x - p.x)))
	} else if abs(head.x - p.x) + abs(head.y - p.y) >= 3 {
		p.offset(int(sign(head.x - p.x)), int(sign(head.y - p.y)))
	} else {
		*p
	}
}

fn (p &Position) str() string {
	return '${p.x}_${p.y}'
}

struct Instruction {
	direction u8
	steps     int
}

fn main() {
	println(part1(process_data(read_file('ropes-part1.input')!)))
	println(part2(process_data(read_file('ropes-part2.input')!)))
}

fn part1(data []Instruction) int {
	return traverse(data, 2)
}

fn part2(data []Instruction) int {
	return traverse(data, 10)
}

fn traverse(data []Instruction, len int) int {
	mut traversed_points := map[string]bool{}
	mut knots := []Position{len: len, init: Position{0, 0}}

	for instruction in data {
		for _ in 0 .. instruction.steps {
			knots[0] = knots[0].move_head(instruction.direction)

			for i in 1 .. len {
				knots[i] = knots[i].follow_head(knots[i - 1])
			}

			traversed_points[knots[len - 1].str()] = true
		}
	}

	return traversed_points.len
}

fn process_data(data string) []Instruction {
	return data.replace('\r\n', '\n').split('\n').filter(it != '').map(fn (line string) Instruction {
		line_segment := line.split(' ')
		return Instruction{
			direction: line_segment[0][0]
			steps:     line_segment[1].int()
		}
	})
}
