module main

import os
import arrays

const symbols = ['$'[0], '+'[0], '@'[0], '-'[0], '='[0], '*'[0], '!'[0], '#'[0], '&'[0], '%'[0],
	'/'[0]]

fn main() {
	lines := os.read_lines('schematic.input')!
	println('Part 1: ${solve(lines, false)}')
	println('Part 2: ${solve(lines, true)}')
}

fn solve(lines []string, part_2 bool) int {
	mut coords := [][]int{}
	mut total := 0
	for i := 0; i < lines.len; i++ {
		for j := 0; j < lines[i].len; j++ {
			if lines[i][j] in symbols {
				mut temp := []int{}
				temp << explore(lines, i - 1, j - 1)
				temp << explore(lines, i - 1, j)
				temp << explore(lines, i - 1, j + 1)
				temp << explore(lines, i, j - 1)
				temp << explore(lines, i, j + 1)
				temp << explore(lines, i + 1, j - 1)
				temp << explore(lines, i + 1, j)
				temp << explore(lines, i + 1, j + 1)
				coords << arrays.uniq(temp.filter(it != 0))
			}
		}
	}
	if part_2 {
		for line in coords.filter(it.len == 2) {
			total += line[0] * line[1]
		}
	} else {
		for line in coords {
			total += arrays.sum[int](line) or { panic(err) }
		}
	}
	return total
}

fn explore(lines []string, row int, col int) int {
	lines[row] or { return 0 }.substr_with_check(col, col) or { return 0 }
	if lines[row][col] == '.'[0] {
		return 0
	}
	mut beg := col
	mut end := col
	for beg > 0 {
		if lines[row][beg - 1] == '.'[0] || lines[row][beg - 1] in symbols {
			break
		}
		beg -= 1
	}
	for end < lines[row].len - 1 {
		if lines[row][end + 1] == '.'[0] || lines[row][end + 1] in symbols {
			break
		}
		end += 1
	}
	return lines[row].substr(beg, end + 1).int()
}
