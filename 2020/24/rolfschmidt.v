// $origin: https://github.com/rolfschmidt/advent-of-code

module main

import os
import pcre

[inline]
fn d24_run(part2 bool) int {
	mut lines := read_day('24.input')
	mut matrix := []string{}
	for line in lines {
		directions := regex_split(line, r'(e|se|sw|w|nw|ne)')
		mut cx := 0
		mut cy := 0
		mut cz := 0
		for d in directions {
			if d == 'e' {
				cx++
				cy--
			} else if d == 'se' {
				cz++
				cy--
			} else if d == 'sw' {
				cx--
				cz++
			} else if d == 'w' {
				cx--
				cy++
			} else if d == 'nw' {
				cz--
				cy++
			} else if d == 'ne' {
				cx++
				cz--
			}
		}
		pos := '${cx}_${cy}_$cz'
		if pos in matrix {
			matrix.delete(matrix.index(pos))
		} else {
			matrix << pos
		}
	}
	if !part2 {
		return matrix.len
	}
	nbrs := [[0, 1, -1], [1, 0, -1],
		[1, -1, 0], [0, -1, 1], [-1, 0, 1], [-1, 1, 0]]
	for _ in 0 .. 100 {
		mut new_matrix := map[string]bool{}
		for tile in matrix {
			pos := tile.split('_').map(it.int())
			mut nbr_count := 0
			for nbr in nbrs {
				pos_nbr_str := '${pos[0] + nbr[0]}_${pos[1] + nbr[1]}_${pos[2] + nbr[2]}'
				if pos_nbr_str in matrix {
					nbr_count++
				} else {
					mut white_black_count := 0
					for white_nbr in nbrs {
						white_nbr_pos_str := '${pos[0] + nbr[0] + white_nbr[0]}_${pos[1] + nbr[1] +
							white_nbr[1]}_${pos[2] + nbr[2] + white_nbr[2]}'
						if white_nbr_pos_str in matrix {
							white_black_count++
						}
					}
					if white_black_count == 2 {
						new_matrix[pos_nbr_str] = true
					}
				}
			}
			if nbr_count == 1 || nbr_count == 2 {
				new_matrix[tile] = true
			}
		}
		matrix = new_matrix.keys()
	}
	return matrix.len
}

fn day24a() int {
	return d24_run(false)
}

fn day24b() int {
	return d24_run(true)
}

fn main() {
	println(day24a())
	println(day24b())
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
