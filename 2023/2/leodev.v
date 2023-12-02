import os { read_file }

const max_red = 12
const max_green = 13
const max_blue = 14

struct Game {
	idx   int
	draws []Pair
}

struct Pair {
	amount int
	color  Color
}

enum Color {
	red
	green
	blue
}

fn main() {
	inputs := read_file('cube.input')!.split_into_lines()
	mut games := []Game{}
	for line in inputs {
		parts := line.split(': ')
		game_idx := parts[0].split(' ')[1].int()
		mut draws := []Pair{}
		for draw in parts[1].split('; ') {
			for pair in draw.split(', ') {
				pair_parts := pair.split(' ')
				amount := pair_parts[0].int()
				color := match pair_parts[1] {
					'red' { Color.red }
					'green' { Color.green }
					'blue' { Color.blue }
					else { panic('unexpected color ${pair_parts[1]}') }
				}
				draws << Pair{amount, color}
			}
		}
		games << Game{game_idx, draws}
	}

	println(part1(games))
	println(part2(games))
}

fn part1(games []Game) int {
	mut sum := 0
	game: for game in games {
		for draw in game.draws {
			max := match draw.color {
				.red { max_red }
				.green { max_green }
				.blue { max_blue }
			}
			if draw.amount > max {
				continue game
			}
		}
		sum += game.idx
	}
	return sum
}

fn part2(games []Game) int {
	mut sum := 0
	for game in games {
		mut highest_red := 0
		mut highest_green := 0
		mut highest_blue := 0
		for draw in game.draws {
			match draw.color {
				.red {
					if draw.amount > highest_red {
						highest_red = draw.amount
					}
				}
				.green {
					if draw.amount > highest_green {
						highest_green = draw.amount
					}
				}
				.blue {
					if draw.amount > highest_blue {
						highest_blue = draw.amount
					}
				}
			}
		}

		sum += highest_red * highest_green * highest_blue
	}
	return sum
}
