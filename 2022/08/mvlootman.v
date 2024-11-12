import os
import arrays { max }

struct Grid {
	height int
	width  int
mut:
	grid [][]int
}

fn main() {
	lines := os.read_lines('trees.input')!
	g := new_grid(lines)
	part1 := g.part1()
	part2 := g.part2()

	println('Part1: ${part1}')
	println('Part2: ${part2}')
}

fn new_grid(lines []string) Grid {
	mut grid := [][]int{}
	for l in lines {
		grid << l.split('').map(it.int())
	}

	return Grid{
		height: lines.len
		width:  lines[0].len
		grid:   grid
	}
}

fn (g Grid) part1() int {
	mut visible_trees := 0
	for y in 0 .. g.height {
		for x in 0 .. g.width {
			tree_val := g.grid[y][x]

			row_vals := g.get_row(y)
			// look left/right
			if row_vals[0..x].all(it < tree_val) || row_vals[x + 1..].all(it < tree_val) {
				visible_trees += 1
				continue
			}

			col_vals := g.get_col(x)
			// look up/down
			if col_vals[0..y].all(it < tree_val) || col_vals[y + 1..].all(it < tree_val) {
				visible_trees += 1
				continue
			}
		}
	}
	return visible_trees
}

fn (g Grid) part2() int {
	mut scores := []int{}

	// sceneric score per item
	for y in 0 .. g.height - 1 {
		for x in 0 .. g.width - 1 {
			tree_val := g.grid[y][x]

			row_vals := g.get_row(y)
			mut left_score := 0
			// look left
			for n in row_vals[0..x].reverse() {
				left_score += 1
				if n >= tree_val {
					break
				}
			}
			mut right_score := 0
			// look right
			for n in row_vals[x + 1..] {
				right_score += 1
				if n >= tree_val {
					break
				}
			}

			col_vals := g.get_col(x)
			// look up
			mut up_score := 0
			for n in col_vals[0..y].reverse() {
				up_score += 1
				if n >= tree_val {
					break
				}
			}
			// look down
			mut down_score := 0
			for n in col_vals[y + 1..] {
				down_score += 1
				if n >= tree_val {
					break
				}
			}
			scores << left_score * right_score * up_score * down_score
		}
	}
	return max(scores) or { 0 }
}

fn (g Grid) get_row(x int) []int {
	return g.grid[x]
}

fn (g Grid) get_col(y int) []int {
	mut cols := []int{}

	for r in g.grid {
		cols << r[y]
	}
	return cols
}
