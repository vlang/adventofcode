import os { read_file }

// https://github.com/hillerstorm/aoc2022-v/blob/main/days/day_06.v
fn main() {
	input := read_file('datastream.input')!.trim_space().runes()

	mut start_of_packet := []rune{}
	mut start_of_message := []rune{}

	mut part_one := -1
	mut part_two := -1

	for i, chr in input {
		if part_one == -1 {
			if check_marker(mut start_of_packet, chr, 4) {
				part_one = i + 1

				if part_two > -1 {
					break
				}
			}
		}

		if part_two == -1 {
			if check_marker(mut start_of_message, chr, 14) {
				part_two = i + 1

				if part_one > -1 {
					break
				}
			}
		}
	}

	println(part_one)
	println(part_two)
}

fn check_marker(mut marker []rune, chr rune, marker_length int) bool {
	if chr in marker {
		marker.delete_many(0, marker.index(chr) + 1)
	}

	marker << chr

	return marker.len == marker_length
}
