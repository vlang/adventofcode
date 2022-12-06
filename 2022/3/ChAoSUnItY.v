import os { read_file }
import arrays { chunk, reduce, sum }

fn main() {
	data := read_file('rucksack.input')!

	println(part1(process_data1(data))!)
	println(part2(process_data2(data))!)
}

fn part1(pairs [][]string) !int {
	return sum(pairs.map(common(it)!))!
}

fn part2(clusters [][]string) !int {
	return sum(clusters.map(common(it)!))!
}

fn common(cluster []string) !int {
	character := intersection(...cluster.map(it.bytes()))![0]

	return if character >= 65 && character <= 90 {
		character - 65 + 27
	} else {
		character - 97 + 1
	}
}

fn intersection(arrays ...[]u8) ![]u8 {
	return reduce(arrays, fn (acc []u8, elem []u8) []u8 {
		return acc.filter(elem.contains(it))
	})!
}

fn process_data1(data string) [][]string {
	mut result := [][]string{}

	for line in data.replace('\r\n', '\n').split('\n') {
		len := line.len / 2

		result << [line[..len], line[len..]]
	}

	return result
}

fn process_data2(data string) [][]string {
	mut result := [][]string{}

	for cluster in chunk(data.replace('\r\n', '\n').split('\n'), 3) {
		result << cluster
	}

	return result
}
