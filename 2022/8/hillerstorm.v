import arrays { flatten }
import math { floor, max }
import os { read_file }

fn main() {
	lines := read_file('trees.input')!.trim_space().split_into_lines()
	size := lines.len
	grid := flatten(lines.map(it.split('')))

	part_one := count_visible_trees(grid, size)
	part_two := get_max_scenic_score(grid, size)

	println(part_one)
	println(part_two)
}

fn count_visible_trees(grid []string, size int) int {
	mut visible := 0

	outer: for i, height in grid {
		mut x := i % size
		mut y := int(floor(i / size))

		if x == 0 || x == size - 1 || y == 0 || y == size - 1 {
			visible += 1
			continue
		}

		for new_x := x - 1; new_x >= 0; new_x -= 1 {
			new_index := y * size + new_x
			neighbour := grid[new_index]
			if neighbour >= height {
				break
			}
			if new_x == 0 {
				visible += 1
				continue outer
			}
		}

		for new_x := x + 1; new_x < size; new_x += 1 {
			new_index := y * size + new_x
			neighbour := grid[new_index]
			if neighbour >= height {
				break
			}
			if new_x == size - 1 {
				visible += 1
				continue outer
			}
		}

		for new_y := y - 1; new_y >= 0; new_y -= 1 {
			new_index := new_y * size + x
			neighbour := grid[new_index]
			if neighbour >= height {
				break
			}
			if new_y == 0 {
				visible += 1
				continue outer
			}
		}

		for new_y := y + 1; new_y < size; new_y += 1 {
			new_index := new_y * size + x
			neighbour := grid[new_index]
			if neighbour >= height {
				break
			}
			if new_y == size - 1 {
				visible += 1
				continue outer
			}
		}
	}

	return visible
}

fn get_max_scenic_score(grid []string, size int) int {
	mut max_scenic_score := 0

	for i, height in grid {
		mut x := i % size
		mut y := int(floor(i / size))

		mut scenic_score_left := 0
		mut scenic_score_right := 0
		mut scenic_score_above := 0
		mut scenic_score_below := 0

		for new_x := x - 1; new_x >= 0; new_x -= 1 {
			scenic_score_left += 1
			if grid[y * size + new_x] >= height {
				break
			}
		}

		for new_x := x + 1; new_x < size; new_x += 1 {
			scenic_score_right += 1
			if grid[y * size + new_x] >= height {
				break
			}
		}

		for new_y := y - 1; new_y >= 0; new_y -= 1 {
			scenic_score_above += 1
			if grid[new_y * size + x] >= height {
				break
			}
		}

		for new_y := y + 1; new_y < size; new_y += 1 {
			scenic_score_below += 1
			if grid[new_y * size + x] >= height {
				break
			}
		}

		scenic_score := scenic_score_left * scenic_score_right * scenic_score_above * scenic_score_below

		max_scenic_score = max(scenic_score, max_scenic_score)
	}

	return max_scenic_score
}
