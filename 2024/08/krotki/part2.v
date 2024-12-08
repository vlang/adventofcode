module main

import os
import math.vec

fn main() {
	input := os.get_lines()

	xmax := input[0].len
	ymax := input.len

	mut antenas := map[u8][]vec.Vec2[int]{}
	for y, line in input {
		for x, c in line {
			if c != `.` {
				antenas[c] << vec.vec2(x, y)
			}
		}
	}

	mut nodes := []vec.Vec2[int]{}
	for signal in antenas.keys() {
		for a in antenas[signal] {
			bfor: for b in antenas[signal] {
				if a == b {
					continue
				}
				v := a - b
				mut node := a
				if !nodes.contains(node) {
					nodes << node
				}
				for {
					node += v
					if node.x >= 0 && node.y >= 0 && node.x < xmax && node.y < ymax {
						if !nodes.contains(node) {
							nodes << node
						}
					} else {
						continue bfor
					}
				}
			}
		}
	}

	println(nodes.len)
}
