import os
import math

fn main() {
	original_stones := os.read_file('stones.input')!.split(' ').map(it.i64())
	mut stones := original_stones.clone()

	for _ in 0 .. 25 {
		mut new_stones := []i64{cap: stones.len * 2}
		for stone in stones {
			if stone == 0 {
				new_stones << 1
			} else {
				digits := if stone == 10 { 1 } else { int(math.log10(stone)) }
				if digits % 2 == 1 {
					power := i64(math.pow(10, digits / 2 + 1))
					new_stones << stone / power
					new_stones << stone % power
				} else {
					new_stones << stone * 2024
				}
			}
		}

		stones = unsafe { new_stones }
	}

	println('part1: ${stones.len}')

	mut total := i64(0)
	mut b := Bruteforcer{}
	for stone in original_stones {
		total += b.force(stone, 75)
	}

	println('part2: ${total}')
}

struct Bruteforcer {
mut:
	cache map[string]i64
}

fn (mut b Bruteforcer) force(stone i64, rem int) i64 {
	cache_key := '${stone},${rem}'
	if cached := b.cache[cache_key] {
		return cached
	}

	if rem == 0 {
		return 1
	}

	mut total := i64(0)
	if stone == 0 {
		total = b.force(1, rem - 1)
	} else {
		// math.log10(10) is 0.9999999999 and rounds down to 0....
		digits := if stone == 10 { 1 } else { int(math.log10(stone)) }
		if digits % 2 == 1 {
			power := i64(math.pow(10, digits / 2 + 1))
			total = b.force(stone / power, rem - 1) + b.force(stone % power, rem - 1)
		} else {
			total = b.force(stone * 2024, rem - 1)
		}
	}

	b.cache[cache_key] = total
	return total
}
