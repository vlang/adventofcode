module main

import math
import os

struct Game {
	id    int // game ID
	red   int // maximum number of red that appeared in the game
	green int // maximum number of green that appeared in the game
	blue  int // maximum number of blue that appeared in the game
}

// Constructs a Game from a line of the input file
fn Game.new(s string) Game {
	split := s.rsplit(': ')
	id := split[1][5..]
	record := split[0].rsplit('; ')
	mut red := 0
	mut green := 0
	mut blue := 0
	for set in record {
		mut count_red := 0
		mut count_green := 0
		mut count_blue := 0
		counts := set.rsplit(', ')
		for count in counts {
			if count.ends_with(' red') {
				count_red += count.split(' red')[0].int()
			} else if count.ends_with(' green') {
				count_green += count.split(' green')[0].int()
			} else if count.ends_with(' blue') {
				count_blue += count.split(' blue')[0].int()
			}
		}
		red = math.max(red, count_red)
		green = math.max(green, count_green)
		blue = math.max(blue, count_blue)
	}
	return Game{
		id:    id.int()
		red:   red
		green: green
		blue:  blue
	}
}

fn is_valid(game Game) bool {
	// maximum number of cubes of each color in the bag
	max_red := 12
	max_green := 13
	max_blue := 14
	return game.red <= max_red && game.green <= max_green && game.blue <= max_blue
}

fn main() {
	input_path := '../cube.input'

	lines := os.read_lines(input_path) or { panic('Could not read input file.') }
	mut result := 0
	for line in lines {
		game := Game.new(line)
		if is_valid(game) {
			result += game.id
		}
	}
	println('Final result: ${result}')
}
