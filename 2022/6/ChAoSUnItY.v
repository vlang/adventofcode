import os { read_file }

fn main() {
	data := read_file('datastream.input')!

	println(part1(data))
	println(part2(data))
}

fn part1(data string) int {
	for count in 4 .. data.len {
		if !is_duplicate(data[count - 4..count]) {
			return count
		}
	}

	return 0
}

fn part2(data string) int {
	for count in 14 .. data.len {
		if !is_duplicate(data[count - 14..count]) {
			return count
		}
	}

	return 0
}

fn is_duplicate(str string) bool {
	mut m := map[u8]bool{}

	for b in str.bytes() {
		if _ := m[b] {
			return true
		}
		m[b] = true
	}

	return false
}
