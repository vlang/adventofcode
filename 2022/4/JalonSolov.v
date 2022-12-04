import os

lines := os.read_lines('assignments.input')!

mut full_overlaps := 0
mut partial_overlaps := 0

for l in lines {
	pairs := l.split(',')
	left := pairs[0].split('-').map(it.int())
	right := pairs[1].split('-').map(it.int())

	if (left[0] >= right[0] && left[1] <= right[1]) || (right[0] >= left[0] && right[1] <= left[1]) {
		full_overlaps++
	}

	if (left[0] <= right[0] && left[1] >= right[0]) || (right[0] <= left[0] && right[1] >= left[0]) {
		partial_overlaps++
	}
}

println('Full overlaps: ${full_overlaps}, partial overlaps: ${partial_overlaps}')
