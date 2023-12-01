// $origin: https://github.com/rolfschmidt/advent-of-code

module main

import os
import pcre

fn d19_get_rule(rules map[string]string, pos int, crule string, search string) string {
	if rules[pos.str()].contains('"') {
		return rules[pos.str()][1].ascii_str()
	}
	mut rule := '(?:'
	if pos == 0 {
		rule = '^(?:'
	}
	for ch in rules[pos.str()].split(' ') {
		mut groups := regex_match(ch, r'^\d+(.*)?$')
		if groups.len > 0 {
			rule += d19_get_rule(rules, ch.int(), crule + rule, search)
			if groups[1].len > 0 {
				rule += groups[1]
			}
		} else if ch == '|' {
			rule += '|'
		}
	}
	if pos == 0 {
		rule += ')$'
	} else {
		rule += ')'
	}
	return rule
}

fn day19a() int {
	mut lines := read_day_string('19.input')
	data := lines.split('\n\n')
	mut rules := map[string]string{}
	for line in data[0].split('\n') {
		rules[line.all_before(': ')] = line.all_after(': ')
	}
	regex := d19_get_rule(rules, 0, '', '')
	mut count := 0
	for value in data[1].split('\n') {
		if regex_match(value, regex).len > 0 {
			count++
		}
	}
	return count
}

fn day19b() int {
	mut lines := read_day_string('19.input')
	data := lines.split('\n\n')
	mut rules := map[string]string{}
	for line in data[0].split('\n') {
		rules[line.all_before(': ')] = line.all_after(': ')
	}
	rules['8'] = '42+'
	rules['11'] = '42 31 | 42{2} 31{2} | 42{3} 31{3} | 42{4} 31{4}'
	regex := d19_get_rule(rules, 0, '', '')
	mut count := 0
	for value in data[1].split('\n') {
		if regex_match(value, regex).len > 0 {
			count++
		}
	}
	return count
}

fn main() {
	println(day19a())
	// println(day19b())
}

// returns a array of the regex matched strings
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

fn read_day_string(path string) string {
	mut data := os.read_file(path) or { panic(err) }
	return data.trim(' \n\t\v\f\r')
}
