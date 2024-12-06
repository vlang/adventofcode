import os

const direction_vectors = [
	[-1, 0]!,
	[0, 1]!,
	[1, 0]!,
	[0, -1]!,
]!

fn main() {
	lines := os.read_lines('map.input')!

	size_y := lines.len
	size_x := lines[0].len

	mut obstructed := []bool{len: size_y * size_x}

	mut guard_y := 0
	mut guard_x := 0
	mut guard_direction := Direction.up

	for y, line in lines {
		for x, ch in line {
			match ch {
				`^` {
					guard_y = y
					guard_x = x
				}
				`#` {
					obstructed[y * size_y + x] = true
				}
				else {}
			}
		}
	}

	mut traverser := Traverser{
		obstructed:      obstructed
		head:            true
		size_y:          size_y
		size_x:          size_x
		traversed:       []Direction{len: size_y * size_x, init: Direction.blank}
		guard_y:         guard_y
		guard_x:         guard_x
		guard_direction: guard_direction
		loops:           []bool{len: size_y * size_x}
	}
	traverser.run()
	traverser.print()

	travelled := traverser.traversed.count(it != .blank)
	println('part1: ${travelled}')
	obstructions := traverser.loops.count(it)
	println('part2: ${obstructions}')
}

struct Traverser {
	head   bool
	size_y int
	size_x int
mut:
	obstructed      []bool
	traversed       []Direction
	guard_y         int
	guard_x         int
	guard_direction Direction
	loops           []bool
}

fn (mut t Traverser) run() bool {
	mut steps := 0
	for t.in_bounds(t.guard_y, t.guard_x) {
		if t.head {
			println('guard at (${t.guard_y}|${t.guard_x}); moving ${t.guard_direction}')
		}
		steps++
		if steps > t.size_y * t.size_x * 10 {
			return true
		}
		t.traversed[t.guard_y * t.size_y + t.guard_x] = t.guard_direction

		next_y := t.guard_y + direction_vectors[t.guard_direction][0]
		next_x := t.guard_x + direction_vectors[t.guard_direction][1]

		if t.in_bounds(next_y, next_x) && t.obstructed[next_y * t.size_y + next_x] {
			t.guard_direction = unsafe {
				Direction((int(t.guard_direction) + 1) % 4)
			}
		} else {
			if t.head && t.in_bounds(next_y, next_x)
				&& t.traversed[next_y * t.size_y + next_x] == .blank {
				mut cloned := t.clone()
				cloned.traversed[t.guard_y * t.size_y + t.guard_x] = .blank
				cloned.obstructed[next_y * t.size_y + next_x] = true
				if cloned.run() {
					println('obstruction at (${next_y}|${next_x}) worked')
					t.loops[next_y * t.size_y + next_x] = true
					// cloned.print()
				}
			}

			t.guard_y = next_y
			t.guard_x = next_x
		}
	}

	return false
}

fn (t Traverser) in_bounds(y int, x int) bool {
	return y >= 0 && y < t.size_y && x >= 0 && x < t.size_x
}

fn (t Traverser) print() {
	for y in 0 .. t.size_y {
		for x in 0 .. t.size_x {
			match t.traversed[y * t.size_y + x] {
				.up {
					print('^')
				}
				.right {
					print('>')
				}
				.down {
					print('v')
				}
				.left {
					print('<')
				}
				else {
					if t.obstructed[y * t.size_y + x] {
						print('#')
					} else {
						print('.')
					}
				}
			}
		}
		print('\n')
	}
}

fn (t Traverser) clone() Traverser {
	return Traverser{
		head:            false
		size_y:          t.size_y
		size_x:          t.size_x
		obstructed:      t.obstructed.clone()
		traversed:       t.traversed.clone()
		guard_y:         t.guard_y
		guard_x:         t.guard_x
		guard_direction: t.guard_direction
	}
}

enum Direction {
	up
	right
	down
	left
	blank
}
