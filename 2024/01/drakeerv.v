import os
import arrays

fn main() {
	lines := os.read_file('locations.input')!.split_into_lines()

	mut first_numbers := []int{}
	mut second_numbers := []int{}

	for i in 0 .. lines.len {
		numbers := lines[i].split('   ')

		first_numbers << numbers[0].int()
		second_numbers << numbers[1].int()
	}

	first_numbers.sort()
	second_numbers.sort()

	mut total := 0

	for i in 0 .. lines.len {
		mut distance := first_numbers[i] - second_numbers[i]
		if distance < 0 {
			distance = -distance
		}
		total += distance
	}

	println('part1: ${total}')

	second_map := arrays.map_of_counts(second_numbers)

	mut similarity := 0

	for value in first_numbers {
		similarity += second_map[value] * value
	}

	println('part2: ${similarity}')
}
