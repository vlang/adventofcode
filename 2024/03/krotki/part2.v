module main

import os
import regex

fn main() {
	input := os.get_raw_lines_joined()

	mut re := regex.regex_opt(r"(do\(\))|(don't\(\))|(mul\(\d+,\d+\))")!
	list := re.find_all_str(input)

	mut is_enabled := true
	mut sum := 0
	for l in list {
		match l {
			'do()' {
				is_enabled = true
				continue
			}
			"don't()" {
				is_enabled = false
				continue
			}
			else {}
		}
		if is_enabled {
			a, b := l.trim('mul()').split_once(',')?
			sum += a.int() * b.int()
		}
	}

	println(sum)
}
