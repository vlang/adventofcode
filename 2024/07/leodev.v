import os

fn main() {
	lines := os.read_lines('calibration.input')!

	mut total1 := i64(0)
	mut total2 := i64(0)
	for line in lines {
		expected_str, value_str := line.split_once(': ') or { panic(err) }
		expected := expected_str.i64()
		values := value_str.split(' ').map(it.i64())

		if find(expected, 0, values, false) {
			total1 += expected
		}
		if find(expected, 0, values, true) {
			total2 += expected
		}
	}

	println('part1: ${total1}')
	println('part2: ${total2}')
}

fn find(expected i64, current_value i64, remaining_values []i64, part2 bool) bool {
	if remaining_values.len == 0 {
		return expected == current_value
	}
	if current_value > expected {
		return false
	}

	if find(expected, current_value + remaining_values[0], remaining_values[1..], part2) {
		return true
	}
	if part2
		&& find(expected, (current_value.str() + remaining_values[0].str()).i64(), remaining_values[1..], part2) {
		return true
	}
	return find(expected, current_value * remaining_values[0], remaining_values[1..],
		part2)
}
