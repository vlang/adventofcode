import os

fn main() {
	lines := os.read_lines('assignments.input')!
	ranges := lines.map(it.split(',').map(it.split('-').map(it.int())))

	part1 := ranges.map(is_complete_overlap).filter(it).len
	part2 := ranges.map(is_partial_overlap).filter(it).len
	println('Part1: ${part1}\nPart2: ${part2}')
}

fn is_complete_overlap(item [][]int) bool {
	a_start, a_end := item[0][0], item[0][1]
	b_start, b_end := item[1][0], item[1][1]

	return (b_start <= a_start && b_end >= a_end) || (a_start <= b_start && a_end >= b_end)
}

fn is_partial_overlap(item [][]int) bool {
	a_start, a_end := item[0][0], item[0][1]
	b_start, b_end := item[1][0], item[1][1]

	/*
	A	|-----|
	B |-----|

	A	|-----|
	B      |-----|
	*/
	return (b_end >= a_start && b_start <= a_start) || (b_start <= a_end && a_start <= b_start)
}
