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
					mut prio := map[int]int{}
					for n in update {
						for r in rules.filter(it[0] == n && update.contains(it[1])) {
							prio[r[0]] = (prio[r[0]] or { 0 }) - 1
							prio[r[1]] = (prio[r[1]] or { 0 }) + 1
						}
					}
					// dump(prio)
					sorted := update.sorted_with_compare(fn [prio] (a &int, b &int) int {
						return (prio[*b] or { 0 }) - (prio[*a] or { 0 })
					})

					sum += sorted[sorted.len / 2]
					continue updatefor
				}
			}
		}
	}

	println(sum)
}
