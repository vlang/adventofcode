import os

lines := os.read_lines('rucksack.input')!

mut priority_sum := 0
mut badge_sum := 0
mut badge_lines := [3]string{}
mut current_badge_line := 0

for l in lines {
	badge_lines[current_badge_line] = l
	current_badge_line++

	h1 := l[..l.len/2].bytes()
	h2 := l[l.len/2..].bytes()

	for b in h1 {
		if b in h2 {
			priority_sum += match b {
				0x41...0x5A { b - 38 }
				0x61...0x7A { b - 96 }
				else { 0 } // never happen with these inputs
			}
			break
		}
	}

	if current_badge_line > 2 {
		current_badge_line = 0
		b0 := badge_lines[0].bytes()
		b1 := badge_lines[1].bytes()
		b2 := badge_lines[2].bytes()

		for b in b0 {
			if b in b1 {
				if b in b2 {
					badge_sum += match b {
						0x41...0x5A { b - 38 }
						0x61...0x7A { b - 96 }
						else { 0 } // never happen with these inputs
					}
					break
				}
			}
		}
	}
}

println('Priority sum: ${priority_sum}, Badge priority sum: ${badge_sum}')
