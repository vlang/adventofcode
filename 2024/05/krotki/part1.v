module main

import os

fn main() {
	rules := os.get_lines().map(it.split('|').map(it.int()))
	updates := os.get_lines().map(it.split(',').map(it.int()))

	mut sum := 0
	updatefor: for update in updates {
		for i, page in update {
			selected_rules := rules.filter(it[0] == page)
			for rule in selected_rules {
				page_index := update.index(rule[1])
				if page_index == -1 {
					continue
				}
				if i > page_index {
					continue updatefor
				}
			}
		}
		// update is valid at this point
		sum += update[update.len / 2]
	}

	println(sum)
}
