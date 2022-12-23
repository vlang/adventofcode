// $origin: https://github.com/rolfschmidt/advent-of-code

module main

import os

fn d11_toggle_occupied(lines [][]string, occupied_range int, x int, y int) bool {
	mut count := 0
	mut minx := 0
	mut miny := 0
	mut maxx := lines[x].len
	mut maxy := lines.len
	lastx := lines[x].len - 1
	lasty := lines.len - 1
	if occupied_range != 5 {
		minx = x - 1
		miny = y - 1
		maxx = x + 1
		maxy = y + 1
	}
	// left
	for pos in aint_range(x - 1, minx) {
		posx := pos
		posy := y
		if posx < 0 || posx > lastx || posy < 0 || posy > lasty {
			continue
		}
		if posx == x && posy == y {
			continue
		}
		if lines[posy][posx] == 'L' {
			break
		}
		if lines[posy][posx] == '#' {
			count++
			break
		}
	}
	// right
	for pos in aint_range(x + 1, maxx) {
		posx := pos
		posy := y
		if posx < 0 || posx > lastx || posy < 0 || posy > lasty {
			continue
		}
		if posx == x && posy == y {
			continue
		}
		if lines[posy][posx] == 'L' {
			break
		}
		if lines[posy][posx] == '#' {
			count++
			break
		}
	}
	// top
	for pos in aint_range(y - 1, miny) {
		posx := x
		posy := pos
		if posx < 0 || posx > lastx || posy < 0 || posy > lasty {
			continue
		}
		if posx == x && posy == y {
			continue
		}
		if lines[posy][posx] == 'L' {
			break
		}
		if lines[posy][posx] == '#' {
			count++
			break
		}
	}
	// bottom
	for pos in aint_range(y + 1, maxy) {
		posx := x
		posy := pos
		if posx < 0 || posx > lastx || posy < 0 || posy > lasty {
			continue
		}
		if posx == x && posy == y {
			continue
		}
		if lines[posy][posx] == 'L' {
			break
		}
		if lines[posy][posx] == '#' {
			count++
			break
		}
	}
	// left top
	for pos in aint_diagonal_range(x - 1, y - 1, minx, miny) {
		posx := pos[0]
		posy := pos[1]
		if posx < 0 || posx > lastx || posy < 0 || posy > lasty {
			continue
		}
		if posx == x && posy == y {
			continue
		}
		if lines[posy][posx] == 'L' {
			break
		}
		if lines[posy][posx] == '#' {
			count++
			break
		}
	}
	// right top
	for pos in aint_diagonal_range(x + 1, y - 1, maxx, miny) {
		posx := pos[0]
		posy := pos[1]
		if posx < 0 || posx > lastx || posy < 0 || posy > lasty {
			continue
		}
		if posx == x && posy == y {
			continue
		}
		if lines[posy][posx] == 'L' {
			break
		}
		if lines[posy][posx] == '#' {
			count++
			break
		}
	}
	// left bottom
	for pos in aint_diagonal_range(x - 1, y + 1, 0, maxy) {
		posx := pos[0]
		posy := pos[1]
		if posx < 0 || posx > lastx || posy < 0 || posy > lasty {
			continue
		}
		if posx == x && posy == y {
			continue
		}
		if lines[posy][posx] == 'L' {
			break
		}
		if lines[posy][posx] == '#' {
			count++
			break
		}
	}
	// right bottom
	for pos in aint_diagonal_range(x + 1, y + 1, maxx, maxy) {
		posx := pos[0]
		posy := pos[1]
		if posx < 0 || posx > lastx || posy < 0 || posy > lasty {
			continue
		}
		if posx == x && posy == y {
			continue
		}
		if lines[posy][posx] == 'L' {
			break
		}
		if lines[posy][posx] == '#' {
			count++
			break
		}
	}
	return (lines[y][x] == 'L' && count == 0) || (lines[y][x] == '#' && count >= occupied_range)
}

fn d11_run(mut lines [][]string, occupied_range int) int {
	mut counter := 0
	for {
		mut changes := [][]int{}
		for y, line in lines {
			for x, _ in line {
				toggle := d11_toggle_occupied(lines, occupied_range, x, y)
				if toggle {
					changes << [x, y]
				}
			}
		}
		for p in changes {
			lines[p[1]][p[0]] = string_flip(lines[p[1]][p[0]], '#', 'L')
		}
		if changes.len < 1 {
			break
		}
		counter++
	}
	return aastring_count('#', lines)
}

fn day11a() int {
	mut lines := read_day('11.input').map(it.split(''))
	return d11_run(mut lines, 4)
}

fn day11b() int {
	mut lines := read_day('11.input').map(it.split(''))
	return d11_run(mut lines, 5)
}

fn main() {
	println(day11a())
	println(day11b())
}

fn read_day_string(path string) string {
	mut data := os.read_file(path) or { panic(err) }
	return data.trim(' \n\t\v\f\r')
}

fn read_day(path string) []string {
	return read_day_string(path).split_into_lines()
}


// returns flipped value
fn string_flip(value string, a string, b string) string {
	if value == a {
		return b
	} else if value == b {
		return a
	}
	return value
}

// returns count of string in array string
fn astring_count(value string, arr []string) int {
	mut count := 0
	for avalue in arr {
		if avalue == value {
			count++
		}
	}
	return count
}

// returns count of string in array of array strings
fn aastring_count(value string, arr [][]string) int {
	mut count := 0
	for arr1 in arr {
		count += astring_count(value, arr1)
	}
	return count
}

// returns range from value a to b
fn aint_range(from int, to int) []int {
	mut range := []int{}
	if to > from {
		for i := from; i <= to; i++ {
			if i < 0 {
				break
			}
			range << i
		}
	} else {
		for i := from; i >= to; i-- {
			if i < 0 {
				break
			}
			range << i
		}
	}
	return range
}

// returns diagonal range from value a to b
fn aint_diagonal_range(fromx int, fromy int, tox int, toy int) [][]int {
	mut ranges := [][]int{}
	rangex := aint_range(fromx, tox)
	rangey := aint_range(fromy, toy)
	lasty := rangey.len - 1
	for i, x in rangex {
		if i < 0 || i > lasty {
			break
		}
		if x < 0 || rangey[i] < 0 {
			break
		}
		ranges << [x, rangey[i]]
	}
	return ranges
}
