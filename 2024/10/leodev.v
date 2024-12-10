import os

fn main() {
	lines := os.read_lines('map.input')!

	mut trailheads := [][2]int{}
	for y, line in lines {
		for x, c in line {
			if c == `0` {
				trailheads << [y, x]!
			}
		}
	}

	mut state := State{
		lines: lines
	}

	mut total1 := 0
	mut total2 := 0
	for th in trailheads {
		total1 += state.traverse(th[0], th[1])
		total2 += state.part2()
	}

	println('part1: ${total1}')
	println('part2: ${total2}')
}

struct State {
	lines []string
mut:
	trailends map[string]int
}

fn (mut s State) traverse(y int, x int) int {
	s.trailends = map[string]int{}
	s.t(y, x, `0`)
	return s.trailends.len
}

fn (s State) part2() int {
	mut total := 0
	for _, v in s.trailends {
		total += v
	}
	return total
}

const offsets = [
	[0, 1]!,
	[1, 0]!,
	[0, -1]!,
	[-1, 0]!,
]

fn (mut s State) t(y int, x int, current u8) {
	for off in offsets {
		ny := y + off[0]
		nx := x + off[1]
		if ny < 0 || ny >= s.lines.len || nx < 0 || nx >= s.lines[0].len {
			continue
		}
		if s.lines[ny][nx] != current + 1 {
			continue
		}
		if current == `8` {
			s.trailends['${ny},${nx}']++
			continue
		}
		s.t(ny, nx, s.lines[ny][nx])
	}
}
