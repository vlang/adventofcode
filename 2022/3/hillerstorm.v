import os { read_file }

// https://github.com/hillerstorm/aoc2022-v/blob/main/days/day_03.v
fn main() {
	priorities := '_abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'

	lines := read_file('rucksack.input')!.split_into_lines()

	mut part_one := 0
	mut part_two := 0

	for i := 0; i < lines.len; i += 3 {
		mut group_items := map[string]int{}
		for line in lines[i..(i + 3)] {
			half := line.len / 2
			mut items := map[string]bool{}
			mut items_b := map[string]bool{}
			mut one_done := false
			for j, chr in line.split('') {
				if j >= half {
					if chr in items && !one_done {
						part_one += priorities.index(chr) or { 0 }
						one_done = true
					} else if chr !in items_b {
						group_items[chr] += 1
						if group_items[chr] == 3 {
							part_two += priorities.index(chr) or { 0 }
						}
					}
					items_b[chr] = true
				} else {
					if chr !in items {
						items[chr] = true
						items_b[chr] = true
						group_items[chr] += 1
						if group_items[chr] == 3 {
							part_two += priorities.index(chr) or { 0 }
						}
					}
				}
			}
		}
	}

	println(part_one)
	println(part_two)
}
