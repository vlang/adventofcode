module main

import os
import regex

fn main() {
	input := os.get_raw_lines_joined()

	mut re := regex.regex_opt('mul\\(\\d+,\\d+\\)')!
	list := re.find_all_str(input)

	mut sum := 0
	for l in list {
		a, b := l.trim('mul()').split_once(',')?
		sum += a.int() * b.int()
	}

	println(sum)
}
