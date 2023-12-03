module main

import os
import math
import arrays

const red_limit = 12
const green_limit = 13
const blue_limit = 14

fn main() {
	games := os.read_lines('cube.input')!
	total := part_1(games)
	min := part_2(games) or { 0 }
	println('Part 1 Total: ${total}')
	println('Part 2 Total: ${min}')
}

fn part_2(input []string) !int {
	return arrays.sum[int](input.map(it.split(': ')[1]).map(it.split_any(',;').map(it.trim_space().split(' '))).map(it.power()))
}

fn (s [][]string) power() int {
	mut arr := [1, 1, 1]
	for hand in s {
		num := hand[0].int()
		arr[hand[1][0] % 3] = math.max(num, arr[hand[1][0] % 3])
	}
	return arrays.reduce(arr, fn (t1 int, t2 int) int {
		return t1 * t2
	}) or {}
}

fn part_1(input []string) int {
	mut total := 0

	outer: for game in input {
		game_num, turns := game.split_once(': ') or { panic('no delim found') }

		for turn in turns.split(';') {
			for selection in turn.split(',') {
				hand := selection.trim_space().split(' ')
				match hand[1] {
					'red' {
						if hand[0].int() > red_limit {
							continue outer
						}
					}
					'green' {
						if hand[0].int() > green_limit {
							continue outer
						}
					}
					'blue' {
						if hand[0].int() > blue_limit {
							continue outer
						}
					}
					else {}
				}
			}
		}
		total += game_num.split(' ').last().int()
	}
	return total
}
