import os
import arrays { sum }

const draw = 3
const lose = 0
const win = 6
const rock = 1
const paper = 2
const scissors = 3

fn main() {
	lines := os.read_lines('rock_paper_scissors.input')!
	scores := lines.map(it.split(' '))

	part1 := sum(scores.map(score_part1))!
	part2 := sum(scores.map(score_part2))!

	println('Part1: ${part1} \nPart2: ${part2}')
}

fn score_part1(choices []string) int {
	// A -> ROCK
	// B -> PAPER
	// C -> SCISSORS
	// X -> ROCK
	// Y -> PAPER
	// Z -> SCISSORS

	return match choices {
		['A', 'X'] { draw + rock }
		['B', 'X'] { lose + rock }
		['C', 'X'] { win + rock }
		['A', 'Y'] { win + paper }
		['B', 'Y'] { draw + paper }
		['C', 'Y'] { lose + paper }
		['A', 'Z'] { lose + scissors }
		['B', 'Z'] { win + scissors }
		['C', 'Z'] { draw + scissors }
		else { panic('unexpected choices:${choices}') }
	}
}

fn score_part2(choices []string) int {
	// A -> ROCK
	// B -> PAPER
	// C -> SCISSORS
	// X -> LOSE
	// Y -> DRAW
	// Z -> WIN
	return match choices {
		['A', 'X'] { lose + scissors }
		['B', 'X'] { lose + rock }
		['C', 'X'] { lose + paper }
		['A', 'Y'] { draw + rock }
		['B', 'Y'] { draw + paper }
		['C', 'Y'] { draw + scissors }
		['A', 'Z'] { win + paper }
		['B', 'Z'] { win + scissors }
		['C', 'Z'] { win + rock }
		else { panic('unexpected choices:${choices}') }
	}
}
