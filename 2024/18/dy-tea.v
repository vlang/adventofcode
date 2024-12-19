import os
import math
import strconv

const input_file = 'positions.input'

fn print_grid(grid [][]bool) {
	for i in 0 .. grid.len {
		for j in 0 .. grid[i].len {
			print(if grid[i][j] { '#' } else { '.' })
		}
		print('\n')
	}
}

fn solve_maze(grid [][]bool, sx int, sy int, ex int, ey int) int {
	dirs := [[1, 0], [0, -1], [-1, 0], [0, 1]]
	mut queue := [][]int{}
	mut visited := map[string]int{}
	mut min := max_int

	queue << [sx, sy, 0]
	visited['${sx},${sy}'] = 0

	for queue.len > 0 {
		curr := queue[0]

		cx := curr[0]
		cy := curr[1]
		cc := curr[2]

		queue.delete(0)

		if cx == ex && cy == ey {
			min = math.min(min, cc)
			continue
		}

		for i in 0 .. 4 {
			nx, ny := cx + dirs[i][0], cy + dirs[i][1]
			if nx >= 0 && ny >= 0 && ny < grid.len && nx < grid[0].len && !grid[nx][ny] {
				key := '${nx},${ny}'
				nc := cc + 1
				if key !in visited || visited[key] > nc {
					visited[key] = nc
					queue << [nx, ny, nc]
				}
			}
		}
	}

	return min
}

fn p1(input string) ! {
	lines := os.read_lines(input)!

	mut grid := [][]bool{len: 71, init: []bool{len: 71, init: false}}

	for i, line in lines {
		x, y := line.split_once(',') or { '', '' }

		if i == 1024 {
			break
		}

		grid[strconv.atoi(x)!][strconv.atoi(y)!] = true
	}

	println(solve_maze(grid, 0, 0, 70, 70))
}

fn p2(input string) ! {
	lines := os.read_lines(input)!

	mut grid := [][]bool{len: 71, init: []bool{len: 71, init: false}}

	for line in lines {
		x, y := line.split_once(',') or { '', '' }

		grid[strconv.atoi(x)!][strconv.atoi(y)!] = true

		if solve_maze(grid, 0, 0, 70, 70) == max_int {
			print_grid(grid)
			println(line)
			break
		}
	}
}

fn main() {
	p1(input_file)!

	// Note that the example input does not block off the exit and therefore does not have an answer
	p2(input_file)!
}
