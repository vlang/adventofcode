import os

lines := os.read_lines('trees.input')!

// width and height are the same in this case, but it's good general practice
// to use separate variables
grid_height := lines.len
grid_width := lines[0].len

// grid is a 2-dimensional array for the input
mut grid := [][]u8{len: grid_height, init: []u8{cap: grid_width}}
// grid_r90 is the same array, rotated 90 degrees right
mut grid_r90 := [][]u8{len: grid_width, init: []u8{cap: grid_height}}
// trees around the perimeter are automatically visible - no need to process them
mut visible_trees := (grid_width * 2) + ((grid_height - 2) * 2)
// keep track of best scenic view, for part 2
mut best_view := 0

for idx, l in lines {
	for i, c in l {
		ch := c - `0`
		grid[idx] << ch
		grid_r90[i] << ch
	}
}

for row in 1 .. grid_height - 1 {
	for col in 1 .. grid_width - 1 {
		tree := grid[row][col]

		if grid[row][0..col].all(it < tree) || grid[row][col + 1..grid_width].all(it < tree) {
			visible_trees++
			continue
		}

		if grid_r90[col][0..row].all(it < tree)
			|| grid_r90[col][row + 1..grid_height].all(it < tree) {
			visible_trees++
		}
	}
}

println(visible_trees)

for row in 0 .. grid_height - 1 {
	for col in 0 .. grid_width - 1 {
		current_tree_height := grid[row][col]

		mut left := 0

		for other_tree_height in grid[row][..col].reverse() {
			left++
			if other_tree_height >= current_tree_height {
				break
			}
		}

		mut right := 0

		for other_tree_height in grid[row][col + 1..] {
			right++
			if other_tree_height >= current_tree_height {
				break
			}
		}

		mut up := 0

		for other_tree_height in grid_r90[col][..row].reverse() {
			up++
			if other_tree_height >= current_tree_height {
				break
			}
		}

		mut down := 0

		for other_tree_height in grid_r90[col][row + 1..] {
			down++
			if other_tree_height >= current_tree_height {
				break
			}
		}

		view_score := left * right * up * down

		if view_score > best_view {
			best_view = view_score
		}
	}
}

println(best_view)
