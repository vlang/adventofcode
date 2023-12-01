// $origin: https://github.com/rolfschmidt/advent-of-code

module main

import os

struct Tile {
pub mut:
	number string
	data   [][]string
}

fn (tile Tile) str() string {
	return tile.data.map(it.join('')).join('\n')
}

fn (tile Tile) clone() Tile {
	mut tnew := Tile{
		number: tile.number
	}
	tnew.data = tile.data.clone()
	return tnew
}

fn (tile Tile) flip() Tile {
	return Tile{
		number: tile.number
		data: tile.data.map(it.clone().reverse())
	}
}

fn (tile Tile) rotate() Tile {
	mut result := Tile{
		number: tile.number
	}
	for y, yv in tile.data {
		mut xnew := []string{}
		for x, _ in yv {
			xnew << tile.data[yv.len - 1 - x][y]
		}
		result.data << xnew
	}
	return result
}

fn (ctile Tile) combos() []Tile {
	mut tile := ctile
	mut result := []Tile{}
	for _ in 0 .. 4 {
		tile = tile.rotate()
		result << tile.clone()
	}
	tile = tile.flip()
	for _ in 0 .. 4 {
		tile = tile.rotate()
		result << tile.clone()
	}
	return result
}

fn (tile Tile) top() string {
	return tile.data[0].join('')
}

fn (tile Tile) bottom() string {
	return tile.data.last().join('')
}

fn (tile Tile) left() string {
	return tile.data.map(it[0]).join('')
}

fn (tile Tile) right() string {
	return tile.data.map(it[tile.data.len - 1]).join('')
}

fn (tile Tile) borderless() Tile {
	mut result := tile.clone()
	result.data = result.data[1..tile.data.len - 1].map(it[1..it.len - 1])
	return result
}

fn (tile Tile) monster() [][]int {
	return [[0, 0], [1, 1], [3, 0], [1, -1], [1, 0], [1, 1], [3, 0],
		[1, -1], [1, 0], [1, 1], [3, 0], [1, -1], [1, 0], [0, -1],
		[1, 1]]
}

fn (tile Tile) monsters() int {
	mut count := 0
	for sy, yv in tile.data {
		for sx, _ in yv {
			mut x := sx
			mut y := sy
			mut found := true
			for pos in tile.monster() {
				x += pos[0]
				y += pos[1]
				if y < tile.data.len && x < tile.data[y].len && tile.data[y][x] == '#' {
					continue
				}
				found = false
				break
			}
			if found {
				count++
			}
		}
	}
	return count
}

fn result_exists(mut rm map[string]map[string]Tile, x int, y int) bool {
	if x.str() !in rm {
		return false
	}
	if y.str() !in rm[x.str()] {
		return false
	}
	return true
}

fn add_result(mut rm map[string]map[string]Tile, x int, y int, tile Tile) {
	if x.str() !in rm {
		rm[x.str()] = map[string]Tile{}
	}
	rm[x.str()][y.str()] = tile
}

fn d20_run(part2 bool) u64 {
	mut lines := read_day_string('20.input')
	mut tiles := map[string]Tile{}
	mut rm := map[string]map[string]Tile{}
	mut rc := map[string]bool{}
	for i, block in lines.split('\n\n') {
		tn := block.all_after('Tile ').all_before(':')
		image := block.all_after(':\n').split('\n').map(it.split(''))
		tile := Tile{
			number: tn
			data: image
		}
		if i == 0 {
			add_result(mut rm, 0, 0, tile)
			rc[tn] = true
		}
		tiles[tn] = tile
	}
	for rc.len < tiles.len {
		for number, tile in tiles {
			if rc[number] {
				continue
			}
			combos := tile.combos()
			combos: for combo in combos {
				for x, xv in rm {
					for y, rtile in xv {
						if !result_exists(mut rm, x.int() - 1, y.int())
							&& combo.right() == rtile.left() {
							add_result(mut rm, x.int() - 1, y.int(), combo)
							rc[number] = true
							break combos
						} else if !result_exists(mut rm, x.int() + 1, y.int())
							&& combo.left() == rtile.right() {
							add_result(mut rm, x.int() + 1, y.int(), combo)
							rc[number] = true
							break combos
						} else if !result_exists(mut rm, x.int(), y.int() + 1)
							&& combo.top() == rtile.bottom() {
							add_result(mut rm, x.int(), y.int() + 1, combo)
							rc[number] = true
							break combos
						} else if !result_exists(mut rm, x.int(), y.int() - 1)
							&& combo.bottom() == rtile.top() {
							add_result(mut rm, x.int(), y.int() - 1, combo)
							rc[number] = true
							break combos
						}
					}
				}
			}
		}
	}
	mut num_top_left := [0, 0, -1]
	mut num_top_right := [0, 0, -1]
	mut num_bottom_left := [0, 0, -1]
	mut num_bottom_right := [0, 0, -1]
	for x, xv in rm {
		for y, rtile in xv {
			if num_top_left[2] == -1 || (num_top_left[0] >= x.int() && num_top_left[1] <= y.int()) {
				num_top_left = [x.int(), y.int(), rtile.number.int()]
			}
			if num_top_right[2] == -1 || (num_top_right[0] <= x.int()
				&& num_top_right[1] <= y.int()) {
				num_top_right = [x.int(), y.int(), rtile.number.int()]
			}
			if num_bottom_left[2] == -1 || (num_bottom_left[0] >= x.int()
				&& num_bottom_left[1] >= y.int()) {
				num_bottom_left = [x.int(), y.int(), rtile.number.int()]
			}
			if num_bottom_right[2] == -1 || (num_bottom_right[0] <= x.int()
				&& num_bottom_right[1] >= y.int()) {
				num_bottom_right = [
					x.int(),
					y.int(),
					rtile.number.int(),
				]
			}
		}
	}
	if !part2 {
		return u64(num_top_left[2]) * u64(num_top_right[2]) * u64(num_bottom_left[2]) * u64(num_bottom_right[2])
	} else {
		mut monster_tile := Tile{
			number: 'monster'
		}
		mut lg := map[string]map[string]string{}
		for y := num_top_left[1]; y > num_bottom_right[1] - 1; y-- {
			lg[y.str()] = map[string]string{}
			for x in num_top_left[0] .. num_bottom_right[0] + 1 {
				for tx in 0 .. 8 {
					tile := rm[x.str()][y.str()].borderless().flip().rotate().rotate()
					lg[y.str()][tx.str()] += tile.data[tx].join('')
				}
			}
		}
		for y := num_top_left[1]; y > num_bottom_right[1] - 1; y-- {
			for x in 0 .. 8 {
				monster_tile.data << lg[y.str()][x.str()].split('')
			}
		}
		for combo in monster_tile.combos() {
			monster_count := combo.monsters()
			if monster_count > 0 {
				return u64(combo.str().count('#') - (monster_count * combo.monster().len))
			}
		}
	}
	return u64(0)
}

fn day20a() u64 {
	return d20_run(false)
}

fn day20b() u64 {
	return d20_run(true)
}

fn main() {
	println(day20a())
	println(day20b())
}

fn read_day_string(path string) string {
	mut data := os.read_file(path) or { panic(err) }
	return data.trim(' \n\t\v\f\r')
}
