import os
import math

struct Machine {
	lights   []bool
	buttons  [][]u32
	joltages []u32
}

fn generate_combos(mut result [][]int, current []int, start int, n int, k int) {
	if current.len == k {
		result << current.clone()
		return
	}
	for i in start .. n {
		mut next := current.clone()
		next << i
		generate_combos(mut result, next, i + 1, n, k)
	}
}

fn get_combinations(n int, k int) [][]int {
	mut result := [][]int{}
	if k == 0 {
		return [[]]
	}
	if k > n {
		return result
	}
	generate_combos(mut result, []int{}, 0, n, k)
	return result
}

@[direct_array_access]
fn (m Machine) min_light_presses() int {
	button_len := m.buttons.len
	lights_len := m.lights.len
	for press_count in 1 .. button_len {
		combinations := get_combinations(button_len, press_count)
		for combo in combinations {
			mut test := []bool{len: lights_len}
			for button_idx in combo {
				for light_idx in m.buttons[button_idx] {
					test[light_idx] = !test[light_idx]
				}
			}
			if test == m.lights {
				return press_count
			}
		}
	}
	return button_len
}

@[direct_array_access]
fn (m Machine) min_joltage_presses() int {
	n := m.buttons.len
	mm := m.joltages.len

	mut matrix := [][]f64{len: mm, init: []f64{len: n + 1}}
	for eq in 0 .. mm {
		for var in 0 .. n {
			mut affects := false
			for jolt_idx in m.buttons[var] {
				if int(jolt_idx) == eq {
					affects = true
					break
				}
			}
			matrix[eq][var] = if affects { 1.0 } else { 0.0 }
		}
		matrix[eq][n] = f64(m.joltages[eq])
	}

	eps := 1e-9
	mut row := 0
	mut pivot_col := []int{len: n, init: -1}

	for col in 0 .. n {
		if row >= mm {
			break
		}

		mut sel := row
		for i in row .. mm {
			if math.abs(matrix[i][col]) > math.abs(matrix[sel][col]) {
				sel = i
			}
		}

		if math.abs(matrix[sel][col]) < eps {
			continue
		}

		matrix[sel], matrix[row] = matrix[row], matrix[sel]

		div := matrix[row][col]
		for j in col .. n + 1 {
			matrix[row][j] /= div
		}

		for i in 0 .. mm {
			if i != row {
				f := matrix[i][col]
				for j in col .. n + 1 {
					matrix[i][j] -= f * matrix[row][j]
				}
			}
		}

		pivot_col[col] = row
		row++
	}

	mut free_vars := []int{}
	for j in 0 .. n {
		if pivot_col[j] == -1 {
			free_vars << j
		}
	}
	fc := free_vars.len

	mut base := []f64{len: n}
	mut coeff := [][]f64{len: n, init: []f64{len: fc}}
	for var in 0 .. n {
		if pivot_col[var] == -1 {
			for k in 0 .. fc {
				if free_vars[k] == var {
					coeff[var][k] = 1.0
				}
			}
		} else {
			r := pivot_col[var]
			base[var] = matrix[r][n]
			for k in 0 .. fc {
				coeff[var][k] = -matrix[r][free_vars[k]]
			}
		}
	}

	if fc == 0 {
		mut sum := i64(0)
		for var in 0 .. n {
			xi := i64(base[var] + 0.5)
			sum += xi
		}
		return int(sum)
	}

	max_val := 200
	mut best_sum := math.maxof[i64]()
	mut t := []int{len: fc}

	for {
		mut ok := true
		mut sum := i64(0)
		for var in 0 .. n {
			mut xv := base[var]
			for k in 0 .. fc {
				xv += coeff[var][k] * f64(t[k])
			}
			xi := i64(xv + 0.5)
			if math.abs(xv - f64(xi)) > 1e-9 || xi < 0 {
				ok = false
				break
			}
			sum += xi
		}
		if ok && sum < best_sum {
			best_sum = sum
		}
		mut idx := 0
		for idx < fc {
			if t[idx] < max_val {
				t[idx]++
				break
			}
			t[idx] = 0
			idx++
		}
		if idx == fc {
			break
		}
	}
	return int(best_sum)
}

lines := os.read_lines('manual.input')!
machines := lines.map(fn (line string) Machine {
	l, rest := line.split_once(' ') or { panic('Invalid input') }
	lights := l[1..l.len - 1].runes().map(|r| r == `#`)
	b, r := rest.rsplit_once('{') or { panic('Invalid input') }
	bb := b.replace(' ', '')
	buttons := bb[1..bb.len - 1].split(')(').map(|s| s.split(',').map(|d| d.u32()))
	joltages := r[..r.len - 1].split(',').map(|d| d.u32())
	return Machine{lights, buttons, joltages}
})

// part 1
mut sum := 0
for m in machines {
	sum += m.min_light_presses()
}
println(sum)

// part 2
sum = 0
for m in machines {
	sum += m.min_joltage_presses()
}
println(sum)
