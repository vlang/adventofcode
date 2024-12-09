import os
import arrays

fn checksum(disk []int) i64 {
	mut result := i64(0)
	for i, block in disk {
		if block != -1 {
			result += block * i
		}
	}
	return result
}

fn main() {
	mut num_blocks := 0
	disk := arrays.flatten(arrays.chunk(os.read_file('diskmap.input')!.split('').map(it.int()),
		2).map(fn [mut num_blocks] (chunk []int) []int {
		num_blocks += 1

		if chunk.len == 1 {
			return []int{len: chunk[0], init: num_blocks - 1}
		}
		return arrays.flatten([[]int{len: chunk[0], init: num_blocks - 1},
			[]int{len: chunk[1], init: -1}])
	}))

	mut disk1 := disk.clone()
	mut cleared_len := 0
	for i := 0; i < disk1.len; i += 1 {
		if disk1[i] == -1 {
			for j := (disk1.len - 1) - cleared_len; j > i; j -= 1 {
				cleared_len++
				if disk1[j] != -1 {
					disk1[i] = disk1[j]
					disk1[j] = -1
					break
				}
			}
		}
	}

	println('part1: ' + checksum(disk1).str())

	// move whole files if we have space
	mut disk2 := disk.clone()
	mut disk_analysis := arrays.map_of_counts(disk2)
	for block_id := disk_analysis.len - 2; block_id >= 0; block_id -= 1 {
		block_length := disk_analysis[block_id]
		block_start := arrays.index_of_first(disk2, fn [block_id] (idx int, elem int) bool {
			return elem == block_id
		})
		if block_start == -1 {
			continue
		}

		for i := 0; i < block_start; i += 1 {
			if disk2[i] == -1 {
				// we found a free space
				mut space_length := 1
				for j := i + 1; j < disk2.len; j += 1 {
					if disk2[j] == -1 {
						space_length++
					} else {
						break
					}
				}

				if space_length >= block_length {
					// we found a large enough space. set the block and remove the old one
					for j := 0; j < block_length; j += 1 {
						disk2[i + j] = block_id
						disk2[block_start + j] = -1
					}
					break
				}

				i += space_length
			}
		}
	}

	println('part2: ' + checksum(disk2).str())
}
