import arrays { WindowAttribute, window }
import os

fn main() {
	input := os.read_file('datastream.input')!

	part1 := find_distinct_consecutive_runes(input, 4)
	part2 := find_distinct_consecutive_runes(input, 14)

	println('part1: ${part1}\npart2: ${part2}')
}

fn find_distinct_consecutive_runes(input string, size int) int {
	items := window(input.runes(), WindowAttribute{
		size: size
	})

	for i, item in items {
		mut distinct := true
		for n in 0 .. size {
			if item[n] in item[n + 1..] {
				distinct = false
				break
			}
		}
		if distinct {
			pos := i + size
			return pos
		}
	}
	panic('no pattern found with distinct of consecutive runes in input')
}
