module main

import os

struct Pos {
	row int
	col int
}

struct Offset {
	dr int
	dc int
}

fn count_adjacent(grid []u8, rows int, cols int, i int, j int, neighbors []Offset) int {
	mut count := 0

	for offset in neighbors {
		ni := i + offset.dr
		nj := j + offset.dc

		if ni >= 0 && nj >= 0 && ni < rows && nj < cols { // inside grid
			nidx := ni * cols + nj
			if grid[nidx] == `@` {
				count++
				if count >= 4 {
					break
				}
			}
		}
	}
	return count
}

fn main() {
	// Read input file
	content := os.read_file('department.input') or { panic('Failed to read file: ${err}') }
	lines := content.split_into_lines()

	mut grid_lines := []string{}
	for line in lines {
		if line.len > 0 {
			grid_lines << line
		}
	}

	rows := grid_lines.len
	cols := grid_lines[0].len

	mut grid1 := []u8{len: rows * cols, cap: rows * cols}
	mut grid2 := []u8{len: rows * cols, cap: rows * cols}

	for i in 0 .. rows {
		line := grid_lines[i]
		row_start := i * cols
		for j in 0 .. cols {
			grid1[row_start + j] = line[j]
			grid2[row_start + j] = line[j]
		}
	}

	neighbors := [
		Offset{-1, -1}, // diagonal above left
		Offset{-1, 0}, // above
		Offset{-1, 1}, // diagional above right
		Offset{0, -1}, // left
		Offset{0, 1}, // right
		Offset{1, -1}, // diagonal below left
		Offset{1, 0}, // below
		Offset{1, 1}, // diagonal below right
	]

	// Part 1
	mut part1_count := 0
	for i in 0 .. rows {
		row_start := i * cols
		for j in 0 .. cols {
			idx := row_start + j
			if grid1[idx] == `@` {
				adj_count := count_adjacent(grid1, rows, cols, i, j, neighbors)
				if adj_count < 4 {
					part1_count++
				}
			}
		}
	}

	println('Part 1: ${part1_count}')

	// Part 2
	mut total_removed := 0
	mut current_grid := grid2.clone()
	mut changed := true

	mut to_check := []Pos{cap: rows * cols}

	for i in 0 .. rows {
		for j in 0 .. cols {
			to_check << Pos{i, j}
		}
	}

	for changed {
		changed = false
		mut to_remove := []Pos{cap: to_check.len}
		mut next_to_check := []Pos{cap: rows * cols}
		mut modified := []bool{len: rows * cols, init: false}

		for pos in to_check {
			i := pos.row
			j := pos.col
			idx := i * cols + j

			if current_grid[idx] != `@` {
				continue
			}

			adj_count := count_adjacent(current_grid, rows, cols, i, j, neighbors)
			if adj_count < 4 {
				to_remove << pos
			}
		}

		// Remove rolls
		if to_remove.len > 0 {
			changed = true
			total_removed += to_remove.len

			// Mark positions as removed and track their neighbors
			for pos in to_remove {
				i := pos.row
				j := pos.col
				idx := i * cols + j
				current_grid[idx] = `.`
				modified[idx] = true

				// Add neighbors to next iteration's check list
				for offset in neighbors {
					ni := i + offset.dr
					nj := j + offset.dc
					if ni >= 0 && nj >= 0 && ni < rows && nj < cols {
						nidx := ni * cols + nj
						if !modified[nidx] {
							modified[nidx] = true
							next_to_check << Pos{ni, nj}
						}
					}
				}
			}

			to_check = next_to_check.clone()
		} else {
			// No more to remove
			break
		}
	}

	println('Part 2: ${total_removed}')
}
