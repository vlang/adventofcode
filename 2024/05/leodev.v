import os

fn main() {
	lines := os.read_lines('pages.input')!

	mut rules := [][]int{len: 100}
	mut rules2 := [][]int{len: 100}
	mut offset := 0
	for line in lines {
		offset++
		if line == '' {
			break
		}

		a, b := line.split_once('|') or { panic(err) }
		rules[a.int()] << b.int()
		rules2[b.int()] << a.int()
	}

	mut total1 := 0
	mut total2 := 0
	for line in lines[offset..] {
		pages := line.split(',').map(it.int())
		mut valid := true
		outer: for i, page in pages {
			for value in rules[page] {
				idx := pages.index(value)
				if idx < i && idx != -1 {
					println('${value} at ${idx} must be before ${page} at ${i}')
					valid = false
					break outer
				}
			}
		}
		if valid {
			println('valid: ${line}')
			total1 += pages[pages.len / 2]
		} else {
			mut correctly_ordered := []int{}
			mut remaining_pages := pages.clone()
			for remaining_pages.len > 0 {
				outer2: for i, potential in remaining_pages {
					for conflict in remaining_pages[1..] {
						if rules2[potential].contains(conflict) {
							continue outer2
						}
					}
					correctly_ordered << potential
					remaining_pages.delete(i)
					break
				}
			}
			println('corrected: ${correctly_ordered}')
			total2 += correctly_ordered[correctly_ordered.len / 2]
		}
	}

	println('part1: ${total1}')
	println('part2: ${total2}')
}
