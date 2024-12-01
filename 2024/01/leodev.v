import os

fn main() {
	content := os.read_file('locations.input')!
	lines := content.split_into_lines()

	mut left := []int{}
	mut right := []int{}

	for line in lines {
		parts := line.split('   ').map(it.int())
		left << parts[0]
		right << parts[1]
	}

	left.sort()
	right.sort()

	mut total := 0
	for i in 0..left.len {
		mut dis := left[i] - right[i]
		if dis < 0 {
			dis = -dis
		}

		total += dis
	}

	println('part1: $total')

	mut similarity := 0
	for i in 0..left.len {
		// we dont have array.count
		occurences := right.filter(it == left[i])
		similarity += left[i] * occurences.len
	}

	println('part2: $similarity')
}

