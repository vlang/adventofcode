// $origin: https://github.com/rolfschmidt/advent-of-code

module main

import os

struct D3Map {
mut:
	map  []string
	posx int
	posy int
}

fn (p D3Map) tree() bool {
	return p.map[p.posy][p.posx] == `#`
}

fn (mut p D3Map) move(addx int, addy int) bool {
	movey := p.posy + addy
	if movey >= p.map.len {
		return false
	}
	p.posx = (p.posx + addx) % p.map[movey].len
	p.posy = movey
	return true
}

fn (mut p D3Map) tree_count(addx int, addy int) u64 {
	p.posx = 0
	p.posy = 0
	mut tree_count := u64(0)
	for p.move(addx, addy) {
		if !p.tree() {
			continue
		}
		tree_count++
	}
	return tree_count
}

fn d3_parse_map(day_map []string) D3Map {
	return D3Map{
		map:  day_map
		posx: 0
		posy: 0
	}
}

fn day03a() u64 {
	day_map := read_day('3.input')
	mut map_obj := d3_parse_map(day_map)
	return map_obj.tree_count(3, 1)
}

fn day03b() u64 {
	day_map := read_day('3.input')
	mut map_obj := d3_parse_map(day_map)
	return map_obj.tree_count(1, 1) * map_obj.tree_count(3, 1) * map_obj.tree_count(5,
		1) * map_obj.tree_count(7, 1) * map_obj.tree_count(1, 2)
}

fn main() {
	println(day03a())
	println(day03b())
}

fn read_day_string(path string) string {
	mut data := os.read_file(path) or { panic(err) }
	return data.trim(' \n\t\v\f\r')
}

fn read_day(path string) []string {
	return read_day_string(path).split_into_lines()
}
