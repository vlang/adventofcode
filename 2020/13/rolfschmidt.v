// $origin: https://github.com/rolfschmidt/advent-of-code

module main

import os

fn day13a() int {
	mut lines := read_day('13.input')
	starttime := lines[0].int()
	mut time := starttime
	mut busses := lines[1].split(',').map(it.int())
	busses.sort()
	daytime: for {
		mut found := 0
		for bus in busses {
			if bus == 0 {
				continue
			}
			if time % bus != 0 {
				continue
			}
			found = bus
			break
		}
		if found == 0 {
			time++
			continue
		}
		return (time - starttime) * found
	}
	return 0
}

fn day13b() u64 {
	mut lines := read_day('13.input')
	mut time := u64(0)
	mut busses := lines[1].split(',').map(it.u64())
	mut jmp := u64(1)
	for {
		mut found := true
		mut found_busses := []u64{}
		for index, bus in busses {
			if bus == 0 {
				continue
			}
			if (time + u64(index)) % bus == 0 {
				found_busses << bus
				continue
			}
			found = false
		}
		if found_busses.len > 1 {
			jmp = au64_product(found_busses)
		}
		if !found {
			time += jmp
			continue
		}
		return time
	}
	return 0
}

fn main() {
	println(day13a())
	println(day13b())
}

fn read_day_string(path string) string {
	mut data := os.read_file(path) or { panic(err) }
	return data.trim(' \n\t\v\f\r')
}

fn read_day(path string) []string {
	return read_day_string(path).split_into_lines()
}

// returns product of a u64 array
fn au64_product(arr []u64) u64 {
	mut v := arr[0]
	if arr.len > 1 {
		for i in 1 .. arr.len {
			v *= arr[i]
		}
	}
	return v
}
