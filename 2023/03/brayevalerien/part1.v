module main

import os

// Schematic of an engine
struct Schematic {
	grid   []string
	width  int
	height int
}

// Describes a position in a schematic
struct Cursor {
	schematic Schematic
mut:
	x int
	y int
}

fn Schematic.new(lines []string) Schematic {
	if lines.len == 0 {
		panic('Cannot build grid of empty input.')
	}
	if lines[0].len == 0 {
		panic('Cannot build grid from input with empty first line.')
	}
	return Schematic{
		grid: lines
		width: lines[0].len
		height: lines.len
	}
}

fn Cursor.new(schematic Schematic) Cursor {
	return Cursor{
		schematic: schematic
		x: 0
		y: 0
	}
}

fn (schematic &Schematic) str() string {
	mut result := ''
	for line in schematic.grid {
		result += line + '\n'
	}
	return result
}

fn (cursor &Cursor) str() string {
	return '(${cursor.x}, ${cursor.y})'
}

// Moves cursor to the right. If the right border is touched, moves to the beginning of next line.
// Returns true iff the cursor is still in the grid.
fn (mut cursor Cursor) right() bool {
	if cursor.y < cursor.schematic.width - 1 {
		cursor.y += 1
		return true
	} else {
		if cursor.x < cursor.schematic.height - 1 {
			cursor.y = 0
			cursor.x += 1
			return true
		} else {
			return false
		}
	}
}

fn (mut cursor Cursor) move_to(x int, y int) {
	cursor.schematic.check_dims(x, y)
	cursor.x = x
	cursor.y = y
}

fn (schematic &Schematic) is_in_grid(x int, y int) bool {
	return 0 <= x && x <= schematic.width - 1 && 0 <= y && y <= schematic.height - 1
}

// Makes sure a position (x, y) is inside the grid, panics otherwise.
fn (schematic &Schematic) check_dims(x int, y int) {
	if !schematic.is_in_grid(x, y) {
		panic('Cannot get element at (${x}, ${y}): grid dimensions are (${schematic.width}, ${schematic.height})')
	}
}

// Returns the rune at position (x, y), offset by (dir_x, dir_y) (that is (x+dir_x, y+dir_y))
// (x, y) needs to be inside the grid, but (x+dir_x, y+dir_y) can be outside.
// In this case, will return `.`. This allows borders to be ignored.
fn (schematic &Schematic) get_at_off(x int, y int, dir_x int, dir_y int) rune {
	schematic.check_dims(x, y)
	if !schematic.is_in_grid(x + dir_x, y + dir_y) {
		return `.`
	} else {
		return schematic.grid[x + dir_x][y + dir_y]
	}
}

// Returns the rune at position (x, y)
fn (schematic &Schematic) get_at(x int, y int) rune {
	return schematic.get_at_off(x, y, 0, 0)
}

// Returns true iff the provided rune is a digit.
fn is_num(r rune) bool {
	nums := []rune{len: 10, init: index.str()[0]}
	return r in nums
}

// Returns true iff the provided rune is not a number and not `.`.
fn is_char(r rune) bool {
	return !is_num(r) && r != `.`
}

// Returns true iff the cursor is next to a character
fn (cursor &Cursor) has_char_next_to_it() bool {
	// Possible directions:
	// nw n ne
	// w  .  e
	// sw s se
	dirs := [
		[-1, 0], // n
		[-1, 1], // ne
		[0, 1], // e
		[1, 1], // se
		[1, 0], // s
		[1, -1], // sw
		[0, -1], // w
		[-1, -1], // nw
	]
	for dir in dirs {
		if is_char(cursor.schematic.get_at_off(cursor.x, cursor.y, dir[0], dir[1])) {
			return true
		}
	}
	return false
}

// Returns the whole number on which the cursor is, and moves the cursor after the number.
// e.g. in '..457*.', cursor on 5: returns 457 and moves cursor to '*'.
fn (mut cursor Cursor) get_num_at() int {
	// 1. Find num beginning
	// 2. Find num ending
	// 3. Concatenate all digits between beginning and ending
	// 4. Move cursor to ending
	mut beg := cursor.y
	for 0 < beg {
		if !is_num(cursor.schematic.get_at(cursor.x, beg - 1)) {
			break
		} else {
			beg -= 1
		}
	}
	mut end := cursor.y
	for end < cursor.schematic.width - 1 {
		if !is_num(cursor.schematic.get_at(cursor.x, end + 1)) {
			break
		} else {
			end += 1
		}
	}
	mut num := cursor.schematic.get_at(cursor.x, beg).str()
	for y in beg + 1 .. end + 1 {
		num += cursor.schematic.get_at(cursor.x, y).str()
	}
	cursor.move_to(cursor.x, end)
	return num.int()
}

// Returns the final result
fn (mut cursor Cursor) get_sum() int {
	mut result := 0
	for {
		// Check if cursor is a number.
		// If it is not, do nothing.
		// If it is, check all adjacent runes to find character
		if is_num(cursor.schematic.get_at(cursor.x, cursor.y)) {
			if cursor.has_char_next_to_it() {
				result += cursor.get_num_at()
			}
		}
		if !cursor.right() {
			break
		}
	}
	return result
}

fn main() {
	input_path := '../schematic.input'

	lines := os.read_lines(input_path) or { panic('Could not read input file.') }
	schematic := Schematic.new(lines)
	mut cursor := Cursor.new(schematic)

	println('Final result: ${cursor.get_sum()}')
}
