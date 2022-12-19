module main

import arrays { flatten, window }
import math { max, min }
import os { read_lines }

// https://github.com/hillerstorm/aoc2022-v/blob/main/days/day_14.v
fn main() {
	mut grid, min_x, max_x, floor := to_grid(flatten(read_lines('cave.input')!.map(parse_line)))

	mut part_one := -1
	mut part_two := 0

	mut pebbles := 0
	for {
		mut x := 500
		mut y := 0

		if intersects(grid, x, y, floor) {
			part_two = pebbles
			break
		}

		for {
			if !intersects(grid, x, y + 1, floor) {
				y += 1
			} else if !intersects(grid, x - 1, y + 1, floor) {
				x -= 1
				y += 1
			} else if !intersects(grid, x + 1, y + 1, floor) {
				x += 1
				y += 1
			} else {
				pebbles += 1
				grid['${x},${y}'] = true
				break
			}

			if part_one == -1 && (x == min_x || x == max_x || y == floor - 2) {
				part_one = pebbles
			}
		}
	}

	println(part_one)
	println(part_two)
}

fn to_grid(segments [][]Point) (map[string]bool, int, int, int) {
	mut grid := map[string]bool{}
	mut left := 500
	mut right := 0
	mut floor := 0

	for segment in segments {
		from, to := segment[0], segment[1]
		left = min(left, min(from.x, to.x))
		right = max(right, max(from.x, to.x))
		floor = max(floor, max(from.y, to.y))

		if from.x == to.x {
			min_y := min(from.y, to.y)
			max_y := max(from.y, to.y)

			for y in min_y .. max_y + 1 {
				grid['${from.x},${y}'] = true
			}
		} else if from.y == to.y {
			min_x := min(from.x, to.x)
			max_x := max(from.x, to.x)

			for x in min_x .. max_x + 1 {
				grid['${x},${from.y}'] = true
			}
		}
	}

	return grid, left, right, floor + 2
}

fn intersects(grid map[string]bool, x int, y int, floor int) bool {
	return y == floor || '${x},${y}' in grid
}

struct Point {
	x int
	y int
}

fn parse_line(line string) [][]Point {
	return window(line.split(' -> ').map(to_point(it.split(',').map(it.int()))),
		size: 2
	)
}

fn to_point(xy []int) Point {
	return Point{xy[0], xy[1]}
}
