import os
import arrays

lines := os.read_lines('manifolds.input')!
s_index := lines[0].index('S') or { panic('S not found') }

// part 1
mut x_indices := [s_index]
mut count := u64(0)
for y in 0 .. lines.len {
	mut x_after := []int{}
	for x in x_indices {
		if lines[y][x] == `^` {
			count++
			x_after << [x - 1, x + 1]
		} else {
			x_after << x
		}
	}
	mut seen := map[int]bool{}
	for pos in x_after {
		seen[pos] = true
	}
	x_indices = seen.keys()
}
println(count)

// part 2
mut counts := map[int]u64{}
counts[s_index] = 1
for y in 0 .. lines.len {
	mut next := map[int]u64{}
	for x, val in counts {
		if lines[y][x] == `^` {
			next[x - 1] += val
			next[x + 1] += val
		} else {
			next[x] += val
		}
	}
	counts = next.move()
}
println(arrays.sum(counts.values()) or { panic('Failed to sum values') })
