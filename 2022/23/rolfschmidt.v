import os
import arrays

fn solve(part2 bool) int {
	input := os.read_file('23.in') or { '' }
	mut grid := map[string]bool{}

	for y, vy in input.split('\n').map(it.split('')) {
		for x, xv in vy {
			if xv != '#' {
				continue
			}

			grid[[x, y].str()] = true
		}
	}

	mut rules_ordered := ['north', 'south', 'west', 'east']

	mut rules := {
		'north': [[-1, -1], [0, -1], [1, -1]]
		'south': [[-1, 1], [0, 1], [1, 1]]
		'west':  [[-1, -1], [-1, 0], [-1, 1]]
		'east':  [[1, -1], [1, 0], [1, 1]]
	}

	mut move_to := {
		'north': [0, -1]
		'south': [0, 1]
		'west':  [-1, 0]
		'east':  [1, 0]
	}

	add := fn (x []int, y []int) []int {
		return [x[0] + y[0], x[1] + y[1]]
	}
	str2pos := fn (x string) []int {
		return x.replace('[', '').replace(']', '').split(', ').map(it.int())
	}

	mut round := 0
	mut max_rounds := 10
	if part2 {
		max_rounds = 10000
	}

	for round < max_rounds {
		mut moves := map[string][][]int{}

		round++

		for pos_str in grid.keys() {
			pos := str2pos(pos_str)

			mut checks := map[string]bool{}
			for name, pos_list in rules {
				mut any_match := false
				for rule_pos in pos_list {
					if grid[add(pos, rule_pos).str()] {
						any_match = true
					}
				}
				if any_match {
					checks[name] = true
				}
			}

			if checks.len < 1 {
				continue
			}

			for name in rules_ordered {
				if !checks[name] {
					moves_to := add(pos, move_to[name]).str()
					if moves[moves_to].len < 2 {
						moves[moves_to] << pos
					}
					break
				}
			}
		}

		for to, froms in moves {
			if froms.len > 1 {
				continue
			}

			pos := froms.first()
			grid.delete(pos.str())
			grid[to] = true
		}

		rules_ordered << rules_ordered[0]
		rules_ordered.delete(0)

		if moves.len < 1 && part2 {
			break
		}
	}

	if part2 {
		return round
	}

	minx := arrays.min(grid.keys().map(str2pos(it)[0])) or { 0 }
	maxx := arrays.max(grid.keys().map(str2pos(it)[0])) or { 0 }
	miny := arrays.min(grid.keys().map(str2pos(it)[1])) or { 0 }
	maxy := arrays.max(grid.keys().map(str2pos(it)[1])) or { 0 }

	mut result := 0
	for y := miny; y <= maxy; y++ {
		for x := minx; x <= maxx; x++ {
			if grid[[x, y].str()] {
				continue
			}

			result++
		}
	}

	return result
}

fn main() {
	println(solve(false))
	println(solve(true))
}
