import os

const cycles_to_check = [20, 60, 100, 140, 180, 220]

mut x := 1
mut sum := 0
mut display := ''

lines := os.read_lines('crt.input')!

mut cycles := []int{}

for l in lines {
	match l[..4] {
		'noop' {
			cycles << x
		}
		'addx' {
			cycles << x
			cycles << x
			x += l[5..].int()
		}
		else {
			// corrupted data??
		}
	}
}

for i, current_x in cycles {
	if i in cycles_to_check {
		sum += i * cycles[i - 1]
	}

	if i % 40 in [current_x - 1, current_x, current_x + 1] {
		display += '#'
	} else {
		display += '.'
	}

	if (i + 1) % 40 == 0 {
		display += '\n'
	}
}

println(sum)
println(display)
