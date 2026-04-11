import os

lines := os.read_lines('pages.input')!

mut order_rules := [][]int{len: 100}
mut line_offset := 0

for line_offset = 0; line_offset < lines.len; line_offset++ {
	line := lines[line_offset]

	if line == '' {
		line_offset++
		break
	}

	a, b := line.split_once('|')?
	order_rules[a.int()] << b.int()
}
