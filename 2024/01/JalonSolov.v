import math
import os

lines := os.read_lines('locations.input')!

mut list_1 := []int{cap: lines.len}
mut list_2 := []int{cap: lines.len}

for line in lines {
	list_1 << line.int()
	list_2 << line.all_after_last(' ').int()
}

list_1.sort()
list_2.sort()

mut total_distance := 0
mut similarity := 0

for idx, _ in list_1 {
	total_distance += math.abs(list_1[idx] - list_2[idx])
	similarity += list_1[idx] * list_2.filter(it == list_1[idx]).len
}

println('Part 1: ${total_distance}')
println('Part 2: ${similarity}')
