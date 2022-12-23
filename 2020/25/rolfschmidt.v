// $origin: https://github.com/rolfschmidt/advent-of-code

module main

import os

fn d25_loop_size(subj u64, value u64) u64 {
	mut lv := u64(1)
	mut i := u64(0)
	for lv != value {
		i++
		lv *= subj
		lv %= 20201227
	}
	return i
}

fn d25_transform(value u64, range u64) u64 {
	mut result := u64(1)
	for _ in 0 .. range {
		result *= value
		result %= 20201227
	}
	return result
}

fn day25a() u64 {
	mut lines := read_day('25.input').map(it.u64())
	mut r1 := d25_loop_size(7, lines[0])
	return d25_transform(lines[1], r1)
}

fn day25b() u64 {
	return 0
}

fn main() {
	println(day25a())
	println(day25b())
}

fn read_day_string(path string) string {
	mut data := os.read_file(path) or { panic(err) }
	return data.trim(' \n\t\v\f\r')
}

fn read_day(path string) []string {
	return read_day_string(path).split_into_lines()
}
