import os

struct Region {
	id rune
mut:
	area      i64
	perimeter []Perimeter
	sides     []Perimeter
}

struct Perimeter {
	p Point
	d Vector
}

struct Point {
	x int
	y int
}

struct Vector {
	dx int
	dy int
}

fn is_valid_move(row int, col int, max_y int, max_x int) bool {
	return row >= 0 && row < max_y && col >= 0 && col < max_x
}

fn check_cell(mut region &Region, mut visited [][]bool, grid []string, row int, col int, max_y int, max_x int) {
	directions := [[0, 1], [0, -1], [1, 0], [-1, 0]]
	for dir in directions {
		new_row := row + dir[0]
		new_col := col + dir[1]
		// Is the new position on the grid
		if is_valid_move(new_row, new_col, max_y, max_x) {
			// Does new direction match our grid id
			runes := grid[new_row].runes()
			if runes[new_col] == region.id {
				// Have we visited this before
				if !visited[new_row][new_col] {
					// add to region size
					region.area += 1
					// mark as visited
					visited[new_row][new_col] = true
					// recursive directional search
					check_cell(mut region, mut visited, grid, new_row, new_col, max_y,
						max_x)
				}
			} else {
				// edge detected
				region.perimeter << Perimeter{
					p: Point{
						y: row
						x: col
					}
					d: Vector{
						dy: dir[0]
						dx: dir[1]
					}
				}
			}
		} else {
			// grid border, add to perimeter
			region.perimeter << Perimeter{
				p: Point{
					y: row
					x: col
				}
				d: Vector{
					dy: dir[0]
					dx: dir[1]
				}
			}
		}
	}
}

fn main() {
	grid := os.read_lines('garden.input')!

	max_y := grid.len
	max_x := grid[0].len

	// initialize a 2D array to keep track of grid and visited elements
	mut visited := [][]bool{len: max_y, init: []bool{len: max_x}}

	// transverse grid
	mut regions := []Region{}
	for row in 0 .. max_y {
		for col in 0 .. max_x {
			// if element is unvisited:
			if !visited[row][col] {
				// identify new region and give it an identifier (char value)
				visited[row][col] = true
				runes := grid[row].runes()
				mut region := &Region{
					id:   runes[col]
					area: 1
				}
				// check for each direction to see if 0) valid 1) unvisited and 2) matching id
				check_cell(mut region, mut visited, grid, row, col, max_y, max_x)
				regions << region
			}
		}
	}

	mut price := i64(0)
	mut price2 := i64(0)
	for mut r in regions {
		price += r.area * r.perimeter.len

		mut new_set := []Perimeter{}
		for per in r.perimeter {
			new_set << Perimeter{
				p: Point{
					y: per.p.y - per.d.dx
					x: per.p.x + per.d.dy
				}
				d: per.d
			}
		}
		r.sides = set_subtract(r.perimeter, new_set)
		price2 += r.area * r.sides.len
		// println('Region: ${r.id} (Area ${r.area}, Perimeter ${r.perimeter.len}, Sides ${r.sides.len})')
	}
	println('Part 1 total price: ${price}')
	println('Part 2 total price: ${price2}')
}

fn set_subtract[T](set1 []T, set2 []T) []T {
	mut result := []T{}
	for item in set1 {
		if !set2.contains(item) {
			result << item
		}
	}
	return result
}
