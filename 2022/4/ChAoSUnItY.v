import os { read_file }
import arrays { reduce, sum }

fn main() {
	data := read_file('assignments.input')!
	processed_data := process_data(data)

	println(part1(processed_data)!)
	println(part2(processed_data)!)
}

fn part1(data [][][]int) !int {
	return sum(data.map(intersect(it, fn (r_range []int, l_range []int, intersected_range_len int) bool {
		return r_range.len == intersected_range_len || l_range.len == intersected_range_len
	})))!
}

fn part2(data [][][]int) !int {
	return sum(data.map(intersect(it, fn (_ []int, _ []int, intersected_range_len int) bool {
		return intersected_range_len > 0
	})))!
}

fn from_range(range []int) []int {
	mut result := []int{cap: range[1] - range[0]}

	for i in range[0] .. range[1] + 1 {
		result << i
	}

	return result
}

fn intersect(ranges [][]int, cond fn (r_range []int, l_range []int, intersected_range_len int) bool) int {
	r_range, l_range := from_range(ranges[0]), from_range(ranges[1])
	range_len := intersection(r_range, l_range) or { []int{} }.len
	return if cond(r_range, l_range, range_len) {
		1
	} else {
		0
	}
}

fn intersection(arrays ...[]int) ![]int {
	return reduce(arrays, fn (acc []int, elem []int) []int {
		return acc.filter(elem.contains(it))
	})!
}

fn process_data(data string) [][][]int {
	return data.replace('\r\n', '\n')
		.split('\n')
		.map(fn (line string) [][]int {
			return line.split(',')
				.map(fn (range string) []int {
					range_points := range.split('-')

					return [range_points[0].int(), range_points[1].int()]
				})
		})
}
