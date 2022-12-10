import math { abs }
import os { read_lines }

const deltas = {
	'L': [-1, 0]
	'R': [1, 0]
	'U': [0, -1]
	'D': [0, 1]
}

struct Pos {
	x int
	y int
}

// https://github.com/hillerstorm/aoc2022-v/blob/main/days/day_09.v
fn main() {
	moves_part_one := read_lines('ropes-part1.input')!.map(it.split(' '))
	moves_part_two := read_lines('ropes-part2.input')!.map(it.split(' '))

	part_one, _ := solve_both(moves_part_one)
	_, part_two := solve_both(moves_part_two)

	println(part_one)
	println(part_two)
}

fn solve_both(moves [][]string) (int, int) {
	mut rope_segments := []Pos{len: 10, init: Pos{0, 0}}
	mut visited_by_tail := {
		'0_0': true
	}
	mut visited_by_second := {
		'0_0': true
	}

	for move in moves {
		dxy := deltas[move[0]]
		len := move[1].int()

		for _ in 0 .. len {
			mut current_pos := rope_segments[0]
			current_pos = Pos{
				x: current_pos.x + dxy[0]
				y: current_pos.y + dxy[1]
			}

			rope_segments[0] = current_pos
			for i, pos in rope_segments[1..] {
				mut new_pos := pos

				needs_vertical_move := abs(current_pos.y - new_pos.y) == 2
				needs_horizontal_move := abs(current_pos.x - new_pos.x) == 2

				if needs_vertical_move && needs_horizontal_move {
					new_pos = Pos{
						x: new_pos.x + ((current_pos.x - new_pos.x) / 2)
						y: new_pos.y + ((current_pos.y - new_pos.y) / 2)
					}
				} else if needs_vertical_move {
					new_pos = Pos{
						x: current_pos.x
						y: new_pos.y + ((current_pos.y - new_pos.y) / 2)
					}
				} else if needs_horizontal_move {
					new_pos = Pos{
						x: new_pos.x + ((current_pos.x - new_pos.x) / 2)
						y: current_pos.y
					}
				}

				current_pos = new_pos
				rope_segments[i + 1] = new_pos
			}

			visited_by_tail['${rope_segments[9].x}_${rope_segments[9].y}'] = true
			visited_by_second['${rope_segments[1].x}_${rope_segments[1].y}'] = true
		}
	}

	return visited_by_second.len, visited_by_tail.len
}
