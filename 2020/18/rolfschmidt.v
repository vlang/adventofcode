// $origin: https://github.com/rolfschmidt/advent-of-code

module main

import os
import pcre

fn d18_combine(val string, part2 bool) (bool, string) {
	mut ls := val
	mut changed := false
	mut regex_default := r'(\d+)(\*|\+)(\d+)'
	mut regex_equal := regex_default
	mut regex_add := r'(\d+)(\+)(\d+)'
	mut regex := regex_equal
	if part2 {
		regex_equal = r'(?:^|[*\(\)])(\d+)(\*)(\d+)(?:$|[*\(\)])'
		regex = regex_add
	}
	for {
		mut operation := regex_match(ls, regex)
		if operation.len < 1 {
			if part2 && regex == regex_add {
				regex = regex_equal
				ls = d18_reverse_calculation(ls)
				continue
			}
			break
		}
		if part2 && regex == regex_equal {
			operation = regex_match(operation[0], regex_default)
		}
		if operation[2] == '*' {
			ls = ls.replace_once(operation[0], (operation[1].u64() * operation[3].u64()).str())
			if part2 && regex == regex_equal {
				regex = regex_add
				ls = d18_reverse_calculation(ls)
			}
		} else {
			ls = ls.replace_once(operation[0], (operation[1].u64() + operation[3].u64()).str())
		}
		ls = d18_string_drop_clamps(ls)
		changed = true
	}
	return changed, ls
}

fn d18_string_drop_clamps(val string) string {
	mut ls := val
	for {
		operation := regex_match(ls, r'\((\d+)\)')
		if operation.len < 1 {
			break
		}
		ls = ls.replace(operation[0], operation[1])
	}
	return ls
}

fn d18_reverse_calculation(ls string) string {
	mut ls_split := regex_split(ls, r'(\d+|.)').reverse()
	for i, v in ls_split {
		ls_split[i] = string_flip(v, ')', '(')
	}
	return ls_split.join('')
}

fn d18_string_calculate(val string, part2 bool) u64 {
	mut ls := val.replace(' ', '')
	if part2 {
		ls = d18_reverse_calculation(ls)
	}
	mut changed := false
	for {
		changed, ls = d18_combine(ls, part2)
		if !changed {
			break
		}
	}
	return ls.u64()
}

fn day18a() u64 {
	mut lines := read_day('18.input')
	mut result := u64(0)
	for line in lines {
		mut ls := d18_string_calculate(line, false)
		result += ls
	}
	return result
}

fn day18b() u64 {
	mut lines := read_day('18.input')
	mut result := u64(0)
	for line in lines {
		mut ls := d18_string_calculate(line, true)
		result += ls
	}
	return result
}

fn main() {
	println(day18a())
	println(day18b())
}

fn read_day_string(path string) string {
	mut data := os.read_file(path) or { panic(err) }
	return data.trim(' \n\t\v\f\r')
}

fn read_day(path string) []string {
	return read_day_string(path).split_into_lines()
}

// returns flipped value
fn string_flip(value string, a string, b string) string {
	if value == a {
		return b
	} else if value == b {
		return a
	}
	return value
}


// returns a array of the regex matched strings
fn regex_match(value string, query string) []string {
	r := pcre.new_regex(query, 0) or { panic('err $err - value $value - query $query') }
	m := r.match_str(value, 0, 0) or { return [] }
	mut result := []string{}
	for i := 0; i < m.group_size; i++ {
		match_value := m.get(i) or { '' }
		result << match_value
	}
	r.free()
	return result
}

// returns a array of the string splitted by the regex
fn regex_split(value string, query string) []string {
	mut result := []string{}
	mut match_string := value
	for {
		groups := regex_match(match_string, query)
		if groups.len == 0 {
			break
		}
		index := match_string.index(groups[0]) or { 0 }
		result << match_string[0..index + groups[0].len]
		match_string = match_string[index + groups[0].len..]
	}
	if result.len > 0 && match_string.len > 0 {
		result << match_string
	}
	return result
}
