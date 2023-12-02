import os

const nums = {'one': `1`, 'two': `2`, 'three': `3`, 'four': `4`, 'five': `5`, 'six': `6`, 'seven': `7`, 'eight': `8`, 'nine': `9`}

fn calc_calibration(lines []string, part2 bool) int {
	mut calibration_total := 0

	for l in lines {
		mut first_digit := 0
		mut last_digit := 0

		for idx := 0; idx < l.len; idx++ {
			mut c := l[idx]

			if part2 {
				for num in nums.keys() {
					if l[idx..].starts_with(num) {
						c = nums[num]
					}
				}
			}

			match c {
				`1`...`9` {
					if first_digit == 0 {
						first_digit = c - 0x30
						last_digit = first_digit
					} else {
						last_digit = c - 0x30
					}
				}
				else {}
			}
		}

		calibration_total += first_digit * 10 + last_digit
	}

	return calibration_total
}

lines_part1 := os.read_lines('trebuchet-part1.input')!
lines_part2 := os.read_lines('trebuchet-part2.input')!

println('Part 1: ${calc_calibration(lines_part1, false)}')
println('Part 2: ${calc_calibration(lines_part2, true)}')
