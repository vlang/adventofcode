import os

struct Instruction {
	kind string
	val  int
}

fn main() {
	instructions := os.read_lines('crt.input')!.map(parse(it))

	mut register_x := 1
	mut cycle := 0
	mut part1 := 0
	mut part2 := ''
	for instruction in instructions {
		cycle_count := if instruction.kind == 'addx' { 2 } else { 1 }
		for _ in 0 .. cycle_count {
			cycle++
			if cycle == 20 || (cycle - 20) % 40 == 0 {
				part1 += cycle * register_x
			}

			// part 2
			if (cycle - 1) % 40 in [register_x - 1, register_x, register_x + 1] {
				part2 += '#'
			} else {
				part2 += '.'
			}
			if cycle % 40 == 0 {
				part2 += '\n'
			}
		}
		register_x += instruction.val
	}
	println('Part 1: ${part1}')
	println('Part 2: \n${part2}')
}

fn parse(line string) Instruction {
	parts := line.split(' ')
	val := if parts.len > 1 { parts[1].int() } else { 0 }

	return Instruction{
		kind: parts[0]
		val: val
	}
}
