import arrays { flatten, map_of_indexes }
import datatypes { Queue }
import math { max, min }
import os { read_lines }

// https://github.com/hillerstorm/aoc2022-v/blob/main/days/day_12.v
fn main() {
	lines := read_lines('hills.input')!
	mut grid := flatten(lines.map(it.runes()))

	start_index := grid.index(`S`)
	end_index := grid.index(`E`)

	grid[start_index] = `a`
	grid[end_index] = `z`

	indices := map_of_indexes(grid)
	height := lines.len
	width := lines[0].len

	mut part_one := -1
	mut part_two := -1
	for i in indices[`a`] {
		length := bfs(grid, i, end_index, width, height)!

		if i == start_index {
			part_one = length
		}

		if length > -1 && (part_two == -1 || length < part_two) {
			part_two = length
		}
	}

	println(part_one)
	println(part_two)
}

fn bfs(grid []rune, start int, end int, width int, height int) !int {
	mut queue := Queue[int]{}
	queue.push(start)

	mut visited := map[int]int{}
	visited[start] = start

	for !queue.is_empty() {
		curr := queue.pop()!

		if curr == end {
			break
		}

		neighbors := get_neighbours(curr, grid, width, height)
		for next in neighbors {
			if next in visited {
				continue
			}

			queue.push(next)
			visited[next] = curr
		}
	}

	return get_path_length(start, end, visited)
}

fn get_neighbours(current_index int, grid []rune, width int, height int) []int {
	x := current_index % width
	y := int(current_index / width)

	neighbours := [
		y * width + max(x - 1, 0),
		y * width + min(x + 1, width - 1),
		max(y - 1, 0) * width + x,
		min(y + 1, height - 1) * width + x,
	]
	current := int(grid[current_index])

	return neighbours
		.filter(it != current_index && (int(grid[it]) <= current || int(grid[it]) - current == 1))
}

pub fn get_path_length(start int, end int, visited map[int]int) int {
	mut current := end
	if current !in visited {
		return -1
	}

	mut length := 0
	for current != start {
		length += 1
		current = visited[current]
	}

	return length
}
