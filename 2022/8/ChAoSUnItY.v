import os { read_file }
import arrays { flat_map, flat_map_indexed, fold, map_indexed, max }

fn main() {
	data := read_file('trees.input')!
	processed_data := process_data(data)

	println(part1(processed_data))
	println(part2(processed_data)!)
}

fn part1(data [][]int) int {
	return flat_map_indexed[[]int, bool](data, fn [data] (y int, row []int) []bool {
		return map_indexed(row, fn [data, y] (x int, height int) bool {
			return map_indexed(grid_cross_walk(data.len, x, y), fn [data, x, y, height] (i int, grid_walk []int) bool {
				return grid_walk.map(fn [data, x, y, i] (pos int) int {
					return if i < 2 {
						data[y][pos]
					} else {
						data[pos][x]
					}
				}).all(it < height)
			}).any(it)
		}).filter(it)
	}).len
}

fn part2(data [][]int) !int {
	return max(flat_map_indexed[[]int, int](data, fn [data] (y int, row []int) []int {
		return map_indexed(row, fn [data, y] (x int, height int) int {
			return fold(map_indexed(grid_cross_walk(data.len, x, y), fn [data, x, y, height] (i int, grid_walk []int) int {
				mut count := 0

				for pos in grid_walk {
					count++
					h := if i < 2 {
						data[y][pos]
					} else {
						data[pos][x]
					}
					if h >= height {
						break
					}
				}

				return count
			}), 1, fn (acc int, elem int) int {
				return acc * elem
			})
		})
	}))!
}

fn range(size int, start int) [][]int {
	return [[]int{len: start, init: start - it - 1}, []int{len: size - start - 1, init: start + 1 +
		it}]
}

fn grid_cross_walk(size int, start_x int, start_y int) [][]int {
	return flat_map[int, []int]([start_x, start_y], fn [size] (elem int) [][]int {
		return range(size, elem)
	})
}

fn process_data(data string) [][]int {
	return data.replace('\r\n', '\n').split('\n').map(it.split('').map(it.int()))
}
