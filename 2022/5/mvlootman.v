import os
import arrays
import datatypes { Stack }
import regex

fn main() {
	raw := os.read_file('supplystacks.input')!
	parts := raw.split('\n\n')
	start_crates, instructions := parts[0], parts[1]

	// get last line containing the stack numbers
	crate_lines := start_crates.split_into_lines()

	// last number of stack numbers
	last_stack_number := crate_lines.last()
		.split('   ')
		.map(it.trim_space().int())
		.last()

	part1 := process(crate_lines, instructions, last_stack_number, false)!
	part2 := process(crate_lines, instructions, last_stack_number, true)!
	println('Part1: ${part1}\nPart2: ${part2}')
}

fn process(crate_lines []string, instructions string, last_stack_number int, part2 bool) !string {
	mut stacks := []Stack[rune]{len: last_stack_number, init: Stack[rune]{}}

	// add initial crate state to stacks
	for i := 0; i <= crate_lines.len; i++ {
		if i > 1 {
			line := crate_lines[crate_lines.len - i]
			item := arrays.chunk(line.runes(), 4)
			for idx, r in item {
				if r[1] != ` ` {
					stacks[idx].push(r[1])
				}
			}
		}
	}

	// handle instructions
	query := r'move (\d+) from (\d+) to (\d+)'
	mut re := regex.regex_opt(query) or { panic(err) }

	for instruction in instructions.split_into_lines() {
		re.match_string(instruction)
		gl := re.get_group_list()
		count := instruction[gl[0].start..gl[0].end].int()
		from := instruction[gl[1].start..gl[1].end].int()
		to := instruction[gl[2].start..gl[2].end].int()

		mut tmp := []rune{}
		for _ in 0 .. count {
			tmp << stacks[from - 1].pop()!
		}
		if part2 {
			tmp = tmp.reverse()
		}
		for t in tmp {
			stacks[to - 1].push(t)
		}
	}

	// result is top item on each stack combined
	mut result := ''
	for mut s in stacks {
		result += s.pop()!.str()
	}
	return result
}
