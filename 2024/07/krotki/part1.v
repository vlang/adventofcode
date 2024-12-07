module main

import os

fn main() {
	input := os.get_lines()

	ops := ['+', '*']

	mut sum := u64(0)
	for line in input {
		numbers := line.split(' ').map(it.u64())
		mut acc := [numbers[1]]
		for n2 in numbers[2..] {
			mut nacc := []u64{}
			for n1 in acc {
				for op in ops {
					match op {
						'+' { nacc << n1 + n2 }
						'*' { nacc << n1 * n2 }
						else {}
					}
				}
			}
			acc = nacc.clone()
		}
		if acc.contains(numbers[0]) {
			sum += numbers[0]
		}
	}

	println(sum)
}
