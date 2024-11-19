// $origin: https://github.com/rolfschmidt/advent-of-code

module main

import os

fn d22_game(pp1 []int, pp2 []int, part2 bool) ([]int, []int) {
	mut p1 := pp1.clone()
	mut p2 := pp2.clone()
	mut seen := map[string]bool{}
	for p1.len > 0 && p2.len > 0 {
		mut p1_wins := true
		if seen['${p1};${p2}'] && part2 {
			break
		}
		seen['${p1};${p2}'] = true
		p1c := p1[0]
		p2c := p2[0]
		p1.delete(0)
		p2.delete(0)
		if p1c <= p1.len && p2c <= p2.len && part2 {
			pm1, _ := d22_game(p1[0..p1c], p2[0..p2c], part2)
			if pm1.len > 0 {
				p1_wins = true
			} else {
				p1_wins = false
			}
		} else {
			if p1c > p2c {
				p1_wins = true
			} else {
				p1_wins = false
			}
		}
		if p1_wins {
			p1 << p1c
			p1 << p2c
		} else {
			p2 << p2c
			p2 << p1c
		}
	}
	return p1, p2
}

fn d22_run(part2 bool) int {
	mut lines := read_day_string('22.input')
	blocks := lines.split('\n\n')
	mut player1 := blocks[0].all_after(':\n').split('\n').map(it.int())
	mut player2 := blocks[1].all_after(':\n').split('\n').map(it.int())
	player1, player2 = d22_game(player1, player2, part2)
	player1.reverse_in_place()
	player2.reverse_in_place()
	player1 = aint_index(player1).map((it + 1) * player1[it])
	player2 = aint_index(player2).map((it + 1) * player2[it])
	return int_max(aint_sum(player1), aint_sum(player2))
}

fn day22a() int {
	return d22_run(false)
}

fn day22b() int {
	return d22_run(true)
}

fn main() {
	println(day22a())
	println(day22b())
}

fn read_day_string(path string) string {
	mut data := os.read_file(path) or { panic(err) }
	return data.trim(' \n\t\v\f\r')
}

// returns a list of indexes of the array
fn aint_index(arr []int) []int {
	mut result := []int{}
	for i in 0 .. arr.len {
		result << i
	}
	return result
}

// returns sum value of array int
fn aint_sum(arr []int) int {
	mut result := 0
	for value in arr {
		result += value
	}
	return result
}
