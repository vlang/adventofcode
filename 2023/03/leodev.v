import os { read_lines }

fn main() {
	inputs := read_lines('schematic.input')!
	println(part1(inputs))
	println(part2(inputs))
}

fn part1(inputs []string) int {
	mut sum := 0
	for x, input in inputs {
		mut number := 0
		mut found := false
		for y, letter in input {
			if letter >= `0` && letter <= `9` {
				number = number * 10 + letter - u8(`0`)
				if !found {
					for dx in -1..2 {
						for dy in -1..2 {
							if x + dx >= 0 && x + dx < inputs.len && y + dy >= 0 && y + dy < input.len {
								dl := inputs[x + dx][y + dy]
								if dl != `.` && (dl < `0` || dl > `9`) {
									found = true
								}
							}
						}
					}
				}
			} else {
				if found {
					sum += number
				}
				number = 0
				found = false
			}
		}
		if number > 0 && found {
			sum += number
		}
	}
	return sum
}

fn part2(inputs []string) int {
	mut sum := 0
	for x, input in inputs {
		for y, letter in input {
			if letter != `*` { continue }
			mut numbers := []int{}
			for dx in -1..2 {
				for dy in -1..2 {
					if x + dx >= 0 && x + dx < inputs.len && y + dy >= 0 && y + dy < input.len {
						if number := try_read_number(inputs, x + dx, y + dy) {
							numbers << number
							if dy > -1 || (inputs[x + dx][y] >= `0` && inputs[x + dx][y] <= `9`) {
								break
							}
						}
					}
				}
			}
			if numbers.len >= 2 {
				sum += numbers[0] * numbers[1]
			}
		}
	}
	return sum
}

fn try_read_number(inputs []string, x int, y int) ?int {
	if inputs[x][y] < `0` || inputs[x][y] > `9` {
		return none
	}
	mut my := y
	for my > 0 && inputs[x][my - 1] >= `0` && inputs[x][my - 1] <= `9` {
		my--
	}
	mut number := 0
	for my < inputs[x].len && inputs[x][my] >= `0` && inputs[x][my] <= `9` {
		number = number * 10 + inputs[x][my] - u8(`0`)
		my++
	}
	return number
}

