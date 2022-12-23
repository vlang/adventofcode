// $origin: https://github.com/rolfschmidt/advent-of-code

module main

import os

fn d10_run(lines []int) int {
	mut one := 0
	mut three := 0
	for i, value in lines {
		mut prev_value := 0
		if i > 0 {
			prev_value = lines[i - 1]
		}
		match value - prev_value {
			1 {
				one++
			}
			3 {
				three++
			}
			else {
				break
			}
		}
	}
	three++
	return one * three
}

fn d10_arrange(lines []u64) u64 {
	mut nodes := map[string]bool{}
	for num in lines {
		nodes[num.str()] = true
	}
	mut upper := lines.last()
	mut t0 := u64(0)
	mut t1 := u64(0)
	mut t2 := u64(0)
	mut t3 := u64(1)
	for upper > 0 {
		t0 = 0
		if nodes[upper.str()] {
			t0 = t3 + t2 + t1
		}
		t3 = t2
		t2 = t1
		t1 = t0
		upper--
	}
	return t3 + t2 + t1
}

fn day10a() int {
	mut lines := read_day('10.input').map(it.int())
	lines.sort()
	return d10_run(lines)
}

fn day10b() u64 {
	mut lines := read_day('10.input').map(it.u64())
	lines.sort()
	return d10_arrange(lines)
}

fn main() {
	println(day10a())
	println(day10b())
}

fn read_day_string(path string) string {
	mut data := os.read_file(path) or { panic(err) }
	return data.trim(' \n\t\v\f\r')
}

fn read_day(path string) []string {
	return read_day_string(path).split_into_lines()
}
