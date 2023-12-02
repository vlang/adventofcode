import os { read_file }
import regex { regex_opt }
import datatypes { Stack }

// https://github.com/hillerstorm/aoc2022-v/blob/main/days/day_05.v
fn main() {
	parts := read_file('supplystacks.input')!.split('\n\n')
	setup := parts[0].split_into_lines().reverse()
	rows := setup[1..]

	mut indices := []int{}
	for i, chr in setup[0] {
		if chr != ` ` {
			indices << i
		}
	}

	mut part_one := []Stack[rune]{len: indices.len, init: Stack[rune]{}}
	mut part_two := [][]rune{len: indices.len, init: []rune{}}

	for row in rows {
		for i, index in indices {
			if chr := row[index] {
				if chr != ` ` {
					part_one[i].push(chr)
					part_two[i] << chr
				}
			}
		}
	}

	query := r'^move (\d+) from (\d+) to (\d+)$'
	mut re := regex_opt(query) or { panic('invalid move: ${err}') }

	for move in parts[1].split_into_lines() {
		re.match_string(move)
		groups := re.get_group_list().map(move[it.start..it.end].int())

		amount := groups[0]
		from := groups[1] - 1
		to := groups[2] - 1

		for _ in 0 .. amount {
			part_one[to].push(part_one[from].pop()!)
		}

		part_two[to] << part_two[from]#[-amount..]
		part_two[from].trim(part_two[from].len - amount)
	}

	println(part_one.map(it.peek()!).string())
	println(part_two.map(it.last()).string())
}
