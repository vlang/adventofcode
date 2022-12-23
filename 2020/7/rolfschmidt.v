// $origin: https://github.com/rolfschmidt/advent-of-code

module main

import os

struct D7Bag {
pub mut:
	name  string
	count int = 1
	bags  []D7Bag
	shiny bool
}

fn (mut bags []D7Bag) make_shiny(name string) []D7Bag {
	for mut bag in bags {
		if bag.shiny {
			continue
		}
		for inner_bag in bag.bags {
			if inner_bag.name != name {
				continue
			}
			bag.shiny = true
			bags.make_shiny(bag.name)
		}
	}
	return bags
}

fn (mut bags []D7Bag) count_shiny(name string) int {
	mut result := 0
	for mut bag in bags {
		if bag.name != name {
			continue
		}
		for inner_bag in bag.bags {
			result += inner_bag.count
			result += inner_bag.count * bags.count_shiny(inner_bag.name)
		}
	}
	return result
}

fn d7_parse_shiny_bags(bag_data string) []D7Bag {
	mut result := []D7Bag{}
	for mut line in bag_data.replace('\n', '').trim_right('.').split('.') {
		bag_split := line.split(' bags contain ')
		mut inner_bags := []D7Bag{}
		for inner_bag in bag_split[1].split(', ') {
			if inner_bag.contains('no other') {
				break
			}
			name := inner_bag.replace(' bags', '').replace(' bag', '')[2..]
			inner_bags << D7Bag{
				name: name
				count: inner_bag[0..2].int()
			}
		}
		result << D7Bag{
			name: bag_split[0]
			bags: inner_bags
		}
	}
	return result
}

fn day07a() int {
	bag_data := read_day_string('7.input')
	mut x := d7_parse_shiny_bags(bag_data)
	y := x.make_shiny('shiny gold')
	return y.filter(it.shiny).len
}

fn day07b() int {
	bag_data := read_day_string('7.input')
	mut x := d7_parse_shiny_bags(bag_data)
	y := x.count_shiny('shiny gold')
	return y
}

fn main() {
	println(day07a())
	println(day07b())
}

fn read_day_string(path string) string {
	mut data := os.read_file(path) or { panic(err) }
	return data.trim(' \n\t\v\f\r')
}
