// $origin: https://github.com/rolfschmidt/advent-of-code
// verify: norun
module main

import os

fn d23_run(part2 bool) string {
	mut input := read_day_string('23.input').split('')
	mut cups := map[string]string{}
	mut curr := ''
	mut prev := ''
	mut input_min := 999
	mut input_max := 0
	mut rounds := 100
	for v in input {
		if curr.len < 1 {
			curr = v
		}
		if prev.len > 0 {
			cups[prev] = v
		}
		prev = v
		input_min = int_min(input_min, v.int())
		input_max = int_max(input_max, v.int())
	}
	if part2 {
		rounds = 10000000
		input_max = 1000000
		for v in 10 .. 1000001 {
			cups[prev] = v.str()
			prev = v.str()
		}
		cups['1000000'] = curr
	} else {
		cups[input.last()] = curr
	}
	for r := 0; r < rounds; r++ {
		p1 := cups[curr]
		p2 := cups[p1]
		p3 := cups[p2]
		mut d := curr.int()
		for d == curr.int() || d == p1.int() || d == p2.int() || d == p3.int() {
			d--
			if d < input_min {
				d = input_max
			}
		}
		cups[curr] = cups[p3]
		dt := cups[d.str()]
		cups[d.str()] = p1
		cups[p3] = dt
		curr = cups[curr]
	}
	if !part2 {
		mut result := ''
		mut si := '1'
		for {
			val := cups[si]
			if val == '1' {
				break
			}
			result += val
			si = val
		}
		return result
	} else {
		return (cups['1'].u64() * cups[cups['1']].u64()).str()
	}
	return '-1'
}

fn day23a() string {
	return d23_run(false)
}

fn day23b() string {
	return d23_run(true)
}

fn main() {
	println(day23a())
	println(day23b())
}

fn read_day_string(path string) string {
	mut data := os.read_file(path) or { panic(err) }
	return data.trim(' \n\t\v\f\r')
}
