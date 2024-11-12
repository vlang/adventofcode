// $origin: https://github.com/rolfschmidt/advent-of-code

module main

import os
import pcre

struct D2Password {
mut:
	min_char     int
	max_char     int
	check_char   string
	check_string string
}

fn (p D2Password) valid() bool {
	return p.check_string.count(p.check_char) >= p.min_char
		&& p.check_string.count(p.check_char) <= p.max_char
}

fn (p D2Password) valid_by_index() bool {
	match_min := p.check_string[p.min_char - 1..p.min_char] == p.check_char
	match_max := p.check_string[p.max_char - 1..p.max_char] == p.check_char
	return match_min != match_max
}

fn d2_parse_password(password string) D2Password {
	groups := regex_match(password, r'(\d+)-(\d+)\s(\w+):\s(\w+)')
	return D2Password{
		min_char:     groups[1].int()
		max_char:     groups[2].int()
		check_char:   groups[3]
		check_string: groups[4]
	}
}

fn day02a() int {
	mut valid_count := 0
	passwords := read_day('2.input')
	for password in passwords {
		password_object := d2_parse_password(password)
		if !password_object.valid() {
			continue
		}
		valid_count++
	}
	return valid_count
}

fn day02b() int {
	mut valid_count := 0
	passwords := read_day('2.input')
	for password in passwords {
		password_object := d2_parse_password(password)
		if !password_object.valid_by_index() {
			continue
		}
		valid_count++
	}
	return valid_count
}

fn main() {
	println(day02a())
	println(day02b())
}

fn read_day_string(path string) string {
	mut data := os.read_file(path) or { panic(err) }
	return data.trim(' \n\t\v\f\r')
}

fn read_day(path string) []string {
	return read_day_string(path).split_into_lines()
}

fn regex_match(value string, query string) []string {
	r := pcre.new_regex(query, 0) or { panic('err ${err} - value ${value} - query ${query}') }
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
