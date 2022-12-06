import os { read_file }
import arrays { sum }

enum Response {
	rock
	paper
	scissors
}

enum Predict {
	lose
	draw
	win
}

struct Strategy {
	response Response
	predict  Predict
}

fn main() {
	data := read_file('rock_paper_scissors.input')!

	println(part1(process_data1(data))!)
	println(part2(process_data2(data))!)
}

fn part1(data [][]Response) !int {
	return sum(data.map(strategy1(it)))!
}

fn part2(data []Strategy) !int {
	return sum(data.map(strategy2(it)))!
}

fn strategy1(strategy []Response) int {
	opponent := strategy[0]
	self := strategy[1]
	mut score := int(self) + 1

	if opponent == self {
		score += 3
	} else if (self == .rock && opponent == .scissors)
		|| (self == .paper && opponent == .rock)
		|| (self == .scissors && opponent == .paper) {
		score += 6
	}

	return score
}

fn strategy2(strategy Strategy) int {
	response := strategy.response
	mut score := int(strategy.predict) * 3

	return match strategy.predict {
		.lose {
			score + match response {
				.rock {
					3
				}
				.paper {
					1
				}
				.scissors {
					2
				}
			}
		}
		.draw {
			score + int(response) + 1
		}
		.win {
			score + match response {
				.rock {
					2
				}
				.paper {
					3
				}
				.scissors {
					1
				}
			}
		}
	}
}

fn process_data1(data string) [][]Response {
	mut result := [][]Response{}

	for line in data.replace('\r\n', '\n').split('\n') {
		if line == '' {
			continue
		}
		unsafe {
			result << [Response(line[0] - 65), Response(line[2] - 88)]
		}
	}

	return result
}

fn process_data2(data string) []Strategy {
	mut result := []Strategy{}

	for line in data.replace('\r\n', '\n').split('\n') {
		if line == '' {
			continue
		}
		unsafe {
			result << Strategy{Response(line[0] - 65), Predict(line[2] - 88)}
		}
	}

	return result
}
