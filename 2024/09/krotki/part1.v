module main

import os
import arrays

struct File {
	id int
mut:
	size int
}

fn main() {
	input := os.get_line().split('').map(it.int())
	// input := '2333133121414131402'.split('').map(it.int())
	mut count := 0
	used, free := arrays.partition(input, fn [mut count] (_ int) bool {
		ret := count % 2 == 0
		count++
		return ret
	})

	mut comp := arrays.map_indexed(used, fn (i int, e int) File {
		return File{ id: i, size: e }
	})

	mut ins := 1
	for f in free {
		for req := f; req > 0; {
			mut last_file := comp.last()
			match true {
				req >= last_file.size {
					comp.insert(ins, last_file)
					comp.delete_last()
					req -= last_file.size
				}
				req < last_file.size {
					comp.insert(ins, File{ id: last_file.id, size: req })
					comp[comp.len - 1].size -= req
					req = 0
				}
				else {}
			}
			ins++
		}
		ins++
		if ins > comp.len {
			break
		}
		// println(comp.map("${it.id} ${it.size}").join(" | "))
	}

	mut sum := u64(0)
	mut counter := u64(0)
	for f in comp {
		for i := f.size; i > 0; i-- {
			sum += counter * u64(f.id)
			counter++
		}
	}

	println(sum)
}
