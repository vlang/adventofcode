module main

import os
import regex
import arrays

struct Monkey {
	id                int
	operation_op      string
	operation_val     string
	divisible_by_test int
	throw_false       int
	throw_true        int
mut:
	items         []i64
	inspect_count i64
}

fn main() {
	part1 := solve(20, true)!
	part2 := solve(10_000, false)!
	println('Part1: ${part1}\nPart2: ${part2}')
}

fn solve(rounds int, part1 bool) !i64 {
	mut monkeys := os.read_file('monkeys.input')!
		.split('\n\n')
		.map(parse_monkey(it.split('\n')))

	for _ in 0 .. rounds {
		advance_round(mut monkeys, part1)
	}

	mut counts := monkeys.map(it.inspect_count)
	counts.sort(b < a)

	return i64(counts[0] * counts[1])
}

fn advance_round(mut monkeys []Monkey, part1 bool) {
	// calculate gcd once (product of all primes (divisible by)) -> math trick
	gcd := arrays.fold(monkeys.map(it.divisible_by_test), 1, fn (i int, acc int) int {
		return acc * i
	})

	for mut monkey in monkeys {
		log('Monkey ${monkey.id}:')
		for item in monkey.items {
			monkey.inspect_count++
			log('\tMonkey inspects an item with a worry level of ${item}.')
			op_str := match monkey.operation_op {
				'+' { 'increased' }
				'*' { 'multiplied' }
				else { panic('unknown op_string:${monkey.operation_op}') }
			}
			other_val := if monkey.operation_val == 'old' {
				item
			} else {
				monkey.operation_val.int()
			}
			mut new_level := match monkey.operation_op {
				'+' { item + other_val }
				'*' { item * other_val }
				else { panic('unknown op_string:${monkey.operation_op}') }
			}
			log('\t\tWorry level ${op_str} by ${monkey.operation_val} to ${new_level}')

			if part1 {
				new_level = new_level / 3
				log('\t\tMonkey gets bored with item. Worry level is divided by 3 to ${new_level}.')
			} else {
				// avoid getting really(!) big numbers
				new_level = new_level % gcd
			}

			if new_level % monkey.divisible_by_test == 0 {
				log('\t\tCurrent worry level is divisible by ${monkey.divisible_by_test}.')
				monkeys[monkey.throw_false].items << new_level
				log('\t\tItem with worry level ${new_level} is thrown to monkey ${monkey.throw_false}.')
			} else {
				log('\t\tCurrent worry level is not divisible by ${monkey.divisible_by_test}.')
				monkeys[monkey.throw_true].items << new_level
				log('\t\tItem with worry level ${new_level} is thrown to monkey ${monkey.throw_true}.')
			}
		}
		monkey.items.clear()
	}
}

fn parse_monkey(monkey_lines []string) Monkey {
	/*
	structure:
	[0]	Monkey 1:
	[1]  		Starting items: 54, 65, 75, 74
	[2]  		Operation: new = old + 6
	[3]  		Test: divisible by 19
	[4]				If true: throw to monkey 2
	[5]				If false: throw to monkey
	*/

	mut number_regex := regex.regex_opt(r'\d+') or { panic(err) }
	mut op_regex := regex.regex_opt(r'\s*Operation: new = old (.) (.+)') or { panic(err) }
	id := number_regex.find_all_str(monkey_lines[0]).map(it.int()).first()
	items := number_regex.find_all_str(monkey_lines[1]).map(it.i64())

	op_regex.match_string(monkey_lines[2])
	op_matches := op_regex.get_group_list().map(monkey_lines[2][it.start..it.end])
	operation_op := op_matches[0]
	operation_val := op_matches[1]

	div_by_test := number_regex.find_all_str(monkey_lines[3]).first().int()
	throw_to_if_false := number_regex.find_all_str(monkey_lines[4]).first().int()
	throw_to_if_true := number_regex.find_all_str(monkey_lines[5]).first().int()

	return Monkey{
		id: id
		items: items
		operation_op: operation_op
		operation_val: operation_val
		divisible_by_test: div_by_test
		throw_false: throw_to_if_false
		throw_true: throw_to_if_true
	}
}

// only execute the log() calls when flag is set e.g.
// v -d write_log mvlootman.v
[if write_log ?]
fn log(s string) {
	println(s)
}

fn print_monkey_items(monkeys []Monkey) {
	for m in monkeys {
		println('Monkey ${m.id}: inspects:${m.inspect_count}\titems: ${m.items}')
	}
}
