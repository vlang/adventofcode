// $origin: https://github.com/rolfschmidt/advent-of-code

module main

import os

fn d9_run(lines []u64, base int) u64 {
	LINES: for i := 0; i < lines.len; i++ {
		mut pre := unsafe { lines[i..i + base] }
		for x := 0; x < pre.len; x++ {
			for y := 0; y < pre.len; y++ {
				if pre[x] != pre[y] && pre[x] + pre[y] == lines[i + base] {
					continue LINES
				}
			}
		}
		return lines[i + base]
	}
	return 0
}

fn d9_set(lines []u64, find u64) u64 {
	for i := 0; i < lines.len; i++ {
		mut values := []u64{}
		for y := i; y < lines.len; y++ {
			values << lines[y]
			if values.len > 1 && au64_sum(values) == find {
				return au64_min(values) + au64_max(values)
			}
		}
	}
	return 0
}

fn day09a() u64 {
	lines := read_day('9.input').map(it.u64())
	return d9_run(lines, 5)
}

fn day09b() u64 {
	lines := read_day('9.input').map(it.u64())
	return d9_set(lines, day09a())
}

fn main() {
	println(day09a())
	println(day09b())
}

fn read_day_string(path string) string {
	mut data := os.read_file(path) or { panic(err) }
	return data.trim(' \n\t\v\f\r')
}

fn read_day(path string) []string {
	return read_day_string(path).split_into_lines()
}

fn au64_min(arr []u64) u64 {
	mut low := u64(0)
	mut found := false
	for value in arr {
		if value < low || !found {
			low = value
			found = true
		}
	}
	return low
}

fn au64_max(arr []u64) u64 {
	mut high := u64(0)
	for value in arr {
		if value > high {
			high = value
		}
	}
	return high
}

fn au64_sum(arr []u64) u64 {
	mut result := u64(0)
	for value in arr {
		result += value
	}
	return result
}
