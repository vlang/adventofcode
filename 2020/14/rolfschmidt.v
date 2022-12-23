// $origin: https://github.com/rolfschmidt/advent-of-code

module main

import os
import pcre

fn bit_combos(arr []int, pos int) [][]int {
	mut result := [][]int{}
	if pos > arr.len - 1 {
		return result
	}
	mut arr_pos := []int{}
	mut arr_neg := []int{}
	for index, value in arr {
		if index == pos {
			arr_pos << 1
			arr_neg << 0
			continue
		}
		arr_pos << value
		arr_neg << value
	}
	result << arr_pos
	result << arr_neg
	for sub in bit_combos(arr_pos, pos + 1) {
		result << sub
	}
	for sub in bit_combos(arr_neg, pos + 1) {
		result << sub
	}
	return result
}

fn day14a() u64 {
	mut lines := read_day('14.input')
	mut masks := map[string][][]u64{}
	mut line_mask := ''
	for line in lines {
		if line.contains('mask') {
			line_mask = line[7..]
		} else {
			groups := regex_match(line, r'mem\[(\d+)\] = (\d+)')
			masks[line_mask] << [groups[1].u64(), groups[2].u64()]
		}
	}
	mut memory := map[string]u64{}
	for mask in masks.keys() {
		for mask_data in masks[mask] {
			addr := mask_data[0]
			number := mask_data[1]
			mut bin := decbin(number, 36).split('')
			for i, v in mask {
				if v == `X` {
					continue
				}
				bin[i] = v.ascii_str()
			}
			memory[addr.str()] = bindec(bin.join(''))
		}
	}
	mut sum := u64(0)
	for _, value in memory {
		sum += value
	}
	return sum
}

fn day14b() u64 {
	mut lines := read_day('14.input')
	mut masks := map[string][][]u64{}
	mut line_mask := ''
	for line in lines {
		if line.contains('mask') {
			line_mask = line[7..]
		} else {
			groups := regex_match(line, r'mem\[(\d+)\] = (\d+)')
			masks[line_mask] << [groups[1].u64(), groups[2].u64()]
		}
	}
	mut memory := map[string]u64{}
	for mask in masks.keys() {
		for mask_data in masks[mask] {
			addr := mask_data[0]
			number := mask_data[1]
			mut bin := decbin(addr, 36).split('')
			mut xarr := []int{}
			for i, v in mask {
				if v == `0` {
					continue
				}
				if v == `X` {
					xarr << i
					continue
				}
				bin[i] = v.ascii_str()
			}
			mut addrs := map[string]bool{}
			mut combos := bit_combos(xarr.map(int(0)), 0)
			for combo in combos {
				for xi, xv in xarr {
					bin[xv] = combo[xi].str()
				}
				addrs[bin.join('')] = true
			}
			for key in addrs.keys() {
				memory[bindec(key).str()] = number
			}
		}
	}
	mut sum := u64(0)
	for _, value in memory {
		sum += value
	}
	return sum
}

fn main() {
	println(day14a())
	println(day14b())
}

fn read_day_string(path string) string {
	mut data := os.read_file(path) or { panic(err) }
	return data.trim(' \n\t\v\f\r')
}

fn read_day(path string) []string {
	return read_day_string(path).split_into_lines()
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

// returns a decimal number out of binary number
// Big thanks to @JalonSolov
fn bindec(b string) u64 {
	mut i := u64(0)
	for idx in b {
		i = i << 1
		if idx == `1` {
			i++
		}
	}
	return i
}

// returns binary number out of decimal number
// Big thanks to @JalonSolov
fn decbin(n u64, length u64) string {
	mut s := ''
	mut u := n
	for u > 0 {
		s += if u & 1 == 1 { '1' } else { '0' }
		u = u >> 1
	}
	if length > 0 {
		for s.len < length {
			s += '0'
		}
	}
	return s.reverse()
}
