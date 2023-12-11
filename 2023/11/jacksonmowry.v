module main

import os
import math

struct Point {
mut:
	o_row  int
	o_col  int
	row    int
	col    int
	row_p2 int
	col_p2 int
}

fn main() {
	mut lines := os.read_lines('stargazing.input')!.map(it.split('').map(it[0]))
	mut coord_pairs := []Point{}
	for row, line in lines {
		for col, symbol in line {
			if symbol == `#` {
				coord_pairs << Point{
					o_row: row
					o_col: col
					row: row
					col: col
					row_p2: row
					col_p2: col
				}
			}
		}
	}
	for row, line in lines {
		if line.any(it == `#`) {
			continue
		}
		for mut point in coord_pairs {
			if point.o_row > row {
				point.row += 1
				point.row_p2 += 999999
			}
		}
	}
	outer: for col := 0; col < lines[0].len; col++ {
		for row := 0; row < lines.len; row++ {
			if lines[row][col] == `#` {
				continue outer
			}
		}
		for mut point in coord_pairs {
			if point.o_col > col {
				point.col += 1
				point.col_p2 += 999999
			}
		}
	}
	mut small_distance := i64(0)
	mut large_distance := i64(0)
	for left_point := 0; left_point < coord_pairs.len - 1; left_point++ {
		for right_point := left_point + 1; right_point < coord_pairs.len; right_point++ {
			small_distance += (
				math.abs(coord_pairs[left_point].row - coord_pairs[right_point].row) +
				math.abs(coord_pairs[left_point].col - coord_pairs[right_point].col))
			large_distance += (
				math.abs(coord_pairs[left_point].row_p2 - coord_pairs[right_point].row_p2) +
				math.abs(coord_pairs[left_point].col_p2 - coord_pairs[right_point].col_p2))
		}
	}
	println('Part 1: ${small_distance}')
	println('Part 1: ${large_distance}')
}
