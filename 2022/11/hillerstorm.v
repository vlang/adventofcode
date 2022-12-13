import os { read_file }
import regex { regex_opt }

// https://github.com/hillerstorm/aoc2022-v/blob/main/days/day_11.v
fn main() {
	lines := read_file('monkeys.input')!.trim_space().split('\n\n')

	println(solve(lines, false)!)
	println(solve(lines, true)!)
}

fn solve(lines []string, part_two bool) !i64 {
	mut monkeys, product := parse_monkeys(lines)

	rounds := if part_two { 10000 } else { 20 }

	for _ in 0 .. rounds {
		for mut monkey in monkeys {
			for item in monkey.items {
				mut worry := monkey.operation(item)

				if part_two {
					worry %= product
				} else {
					worry /= 3
				}

				if worry % monkey.div_by == 0 {
					monkeys[monkey.monkey_if_true].items << worry
				} else {
					monkeys[monkey.monkey_if_false].items << worry
				}
			}

			monkey.inspected += monkey.items.len
			monkey.items.clear()
		}
	}

	monkeys.sort(b.inspected < a.inspected)

	return monkeys[0].inspected * monkeys[1].inspected
}

struct Monkey {
	operation       fn (old i64) i64
	div_by          int
	monkey_if_true  int
	monkey_if_false int
mut:
	items     []i64
	inspected i64
}

fn parse_monkeys(input []string) ([]Monkey, int) {
	mut product := 1
	mut monkeys := []Monkey{len: input.len}

	for i, monkey in input {
		lines := monkey.split_into_lines()

		mut op_regex := regex_opt(r'\s*Operation: new = old (.) (.+)') or { panic(err) }
		op_regex.match_string(lines[2])
		op := op_regex.get_group_list().map(lines[2][it.start..it.end])
		operator := op[0]
		operation_value := op[1]
		operation := fn [operator, operation_value] (old i64) i64 {
			value := match operation_value {
				'old' { old }
				else { operation_value.i64() }
			}

			return match operator {
				'*' { old * value }
				else { old + value }
			}
		}

		mut num_regex := regex_opt(r'\d+') or { panic(err) }
		div_by := num_regex.find_all_str(lines[3]).first().int()
		product *= div_by

		monkeys[i] = Monkey{
			items: num_regex.find_all_str(lines[1]).map(it.i64())
			operation: &operation
			div_by: div_by
			monkey_if_true: num_regex.find_all_str(lines[4]).first().int()
			monkey_if_false: num_regex.find_all_str(lines[5]).first().int()
		}
	}

	return monkeys, product
}
