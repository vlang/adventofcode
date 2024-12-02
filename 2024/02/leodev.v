import os

fn main() {
	content := os.read_file('reports.input')!
	lines := content.split_into_lines()

	mut safe1 := 0
	mut safe2 := 0
	for line in lines {
		levels := line.split(' ').map(it.int())
		if is_safe(levels) {
			safe1++
			safe2++
		} else {
			for i in 0 .. levels.len {
				mut clone := levels.clone()
				clone.delete(i)
				if is_safe(clone) {
					safe2++
					break
				}
			}
		}
	}

	println('part1: ${safe1}')
	println('part2: ${safe2}')
}

fn is_safe(levels []int) bool {
	desc := levels[0] > levels[1]
	for i in 1 .. levels.len {
		prev := levels[i - 1]
		current := levels[i]
		if (prev > current) != desc {
			return false
		}
		delta := prev - current
		if delta == 0 || delta > 3 || delta < -3 {
			return false
		}
	}
	return true
}
