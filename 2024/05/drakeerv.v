import os
import arrays

fn create_inverse_map[T](arr []T) map[T]int {
	mut result := map[T]int{}
	for i, x in arr {
		result[x] = i
	}
	return result
}

fn main() {
	data := os.read_file('pages.input')!.split_into_lines()
	split_index := arrays.index_of_first(data, fn (idx int, x string) bool {
		return x == ''
	})

	mut rules := [][2]int{}
	for rule in data[0..split_index] {
		split := rule.split('|')
		rules << [split[0].int(), split[1].int()]!
	}

	mut total1 := 0
	mut incorect_updates := [][]int{}
	for update in data[split_index + 1..] {
		pages := update.split(',').map(it.int())
		inverse_map := create_inverse_map(pages)

		mut all_passed := true
		for page in pages {
			concerned_rules := rules.filter(it[0] == page || it[1] == page)
			passed := concerned_rules.all(fn [page, inverse_map] (rule [2]int) bool {
				x := rule[0]
				y := rule[1]
				if x == page && y in inverse_map {
					return inverse_map[x] < inverse_map[y]
				} else if y == page && x in inverse_map {
					return inverse_map[x] < inverse_map[y]
				}
				return true
			})

			if !passed {
				all_passed = false
				break
			}
		}

		if all_passed {
			total1 += pages[pages.len / 2]
		} else {
			incorect_updates << pages
		}
	}

	println('part1: ${total1}')

	mut total2 := 0
	for update in incorect_updates {
		sorted_update := update.sorted_with_compare(fn [rules] (a &int, b &int) int {
			a_concerned_rules := rules.filter(it[0] == a || it[1] == a)
			b_concerned_rules := rules.filter(it[0] == b || it[1] == b)

			mut common_rules := [][2]int{}
			for rule in a_concerned_rules {
				if rule in b_concerned_rules {
					common_rules << rule
				}
			}

			if common_rules.len == 0 {
				return 0
			}

			common_rule := common_rules[0]
			if common_rule[0] == a {
				return -1
			} else {
				return 1
			}
		})

		total2 += sorted_update[sorted_update.len / 2]
	}

	println('part2: ${total2}')
}
