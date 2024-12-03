import os
import regex

fn main() {
	content := os.read_file('instructions-part1.input')!

	mut re := regex.regex_opt(r'mul\(\d{1,3},\d{1,3}\)')!
	mut total := 0
	for value in re.find_all_str(content) {
		a, b := value[4..value.len - 1].split_once(',') or { panic(err) }
		total += a.int() * b.int()
	}

	println('part1: ${total}')

	content2 := os.read_file('instructions-part2.input')!

	indexes := re.find_all(content2)
	mut total2 := 0
	for i := 0; i < indexes.len; i += 2 {
		start := indexes[i]
		end := indexes[i + 1]

		before := content2[..start]
		last_do := before.last_index('do()') or { 0 }
		last_dont := before.last_index("don't()") or { -1 }
		if last_dont > last_do {
			continue
		}

		a, b := content2[start + 4..end - 1].split_once(',') or { panic(err) }
		total2 += a.int() * b.int()
	}

	println('part2: ${total2}')
}
