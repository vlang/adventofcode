import os

line := os.read_lines('ids.input')![0]
items := line.split(',')

// part 1
mut sum := u64(0)
for item in items {
	left, right := item.split_once('-') or { panic('invalid input') }
	start := left.u64()
	end := right.u64()
	for i in start .. end + 1 {
		s := i.str()
		if s.len % 2 == 0 {
			if s[0..s.len / 2] == s[s.len / 2..s.len] {
				sum += i
			}
		}
	}
}
println(sum)

// part 2
sum = 0
for item in items {
	left, right := item.split_once('-') or { panic('invalid input') }
	start := left.u64()
	end := right.u64()
	for i in start .. end + 1 {
		s := i.str()
		for x in 1 .. s.len / 2 + 1 {
			if s.len % x == 0 {
				if s[0..x].repeat(s.len / x) == s {
					sum += i
					break
				}
			}
		}
	}
}
println(sum)
