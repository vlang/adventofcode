module main

import os

type FileIndex = File | Free

struct File {
	id int
mut:
	size int
}

struct Free {
	size int
}

fn main() {
	input := os.get_line().split('').map(it.int())
	// input := '2333133121414131402'.split('').map(it.int())

	mut disk := []FileIndex{}
	for i, el in input {
		if i % 2 == 0 {
			disk << File{
				id:   i / 2
				size: el
			}
		} else {
			if el > 0 {
				disk << Free{
					size: el
				}
			}
		}
	}

	// print_disk(disk)

	for file in disk.filter(it is File).reverse() {
		free_space := disk.filter(it is Free && (it as Free).size >= file.size)[0] or { continue } as Free
		free_idx := disk.index(free_space)
		file_idx := disk.index(file)

		if free_idx > file_idx {
			continue
		}

		// replace file with empty space
		disk.delete(file_idx)
		disk.insert(file_idx, Free{ size: file.size })

		merge_free_space(mut disk)

		// insert file
		disk.insert(free_idx, file)
		// shorten free space space
		if free_space.size == file.size {
			disk.delete(free_idx + 1)
		} else {
			disk[free_idx + 1].size -= file.size
		}

		// print_disk(disk)
	}

	mut sum := u64(0)
	mut counter := u64(0)
	for f in disk {
		match f {
			File {
				for i := f.size; i > 0; i-- {
					sum += counter * u64(f.id)
					counter++
				}
			}
			Free {
				counter += u64(f.size)
			}
		}
	}

	println(sum)
}

fn merge_free_space(mut disk []FileIndex) {
	for idx, entry in disk {
		if entry !is Free {
			continue
		}
		next := disk[idx + 1] or { break }
		if next is Free {
			disk[idx].size += disk[idx + 1].size
			disk.delete(idx + 1)
		}
	}
}

fn print_disk(disk []FileIndex) {
	for entry in disk {
		match entry {
			File { print(entry.id.str().repeat(entry.size)) }
			Free { print('.'.repeat(entry.size)) }
		}
	}
	println('')
}
