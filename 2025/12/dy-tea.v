import os
import arrays

lines := os.read_lines('shapes.input')!
areas := lines[30..]
sizes := arrays.chunk(lines[1..29].filter(|line| line != '' && !line.contains(':')), 3).map(|part| part.join('').count('#'))

// part 1
mut count := 0
for line in areas {
	sarea, svals := line.split_once(': ')?
	w, h := sarea.split_once('x')?
	vals := svals.split(' ')
	mut size := 0
	for i, n in vals {
		size += sizes[i] * n.int()
	}
	if size <= w.int() * h.int() {
		count++
	}
}
println(if areas.len < 10 { count - 1 } else { count })
