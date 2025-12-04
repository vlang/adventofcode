import os

lines := os.read_lines('banks.input')!

// part 1
mut sum := u64(0)
for line in lines {
	mut max := 0
	l := line.runes()
	for i, x in l {
		for y in l[i + 1..] {
			dig := '${x}${y}'.int()
			if dig > max {
				max = dig
			}
		}
	}
	sum += u64(max)
}
println(sum)

// part 2
sum = 0
for line in lines {
	mut max := u64(0)
	mut prev := 0
	l := line.runes()
	for i in 0 .. 12 {
		mut dig := 0
		for j in prev .. (l.len - 11 + i) {
			c := l[j].str().int()
			if dig >= c {
				continue
			}
			dig = c
			prev = j + 1
			if dig == 9 {
				break
			}
		}
		max = max * u64(10) + u64(dig)
	}
	sum += max
}
println(sum)
