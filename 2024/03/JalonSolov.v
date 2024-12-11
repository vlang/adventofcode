import regex
import os

instructions := os.read_file('instructions-part2.input')!

mut mul_re := regex.regex_opt(r"(mul\(\d{1,3},\d{1,3}\))|(do(n't)?\(\))")!
mut mul_total := 0
mut enabled_total := 0

mut enabled := true

mut index := 0

for index < instructions.len {
	start, end := mul_re.find_from(instructions, index)
	if start >= 0 {
		group := instructions[start..end]
		match group[0] {
			`m` {
				result := group[4..group.index(',')?].int() * group[group.index(',')? + 1..].int()
				mul_total += result
				if enabled {
					enabled_total += result
				}
			}
			`d` {
				enabled = (group == 'do()')
			}
			else {
				// should never happen
			}
		}
		index = end
	} else {
		break
	}
}

println('Part 1: ${mul_total}')
println('Part 2: ${enabled_total}')
