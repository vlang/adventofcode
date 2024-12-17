import os

enum Direction {
	north = 0
	east  = 1
	south = 2
	west  = 3
}

enum NodeType {
	available
	stuck
	end_
}

enum Tile {
	empty
	wall
}

struct Position {
pub:
	x int
	y int
}

struct Node {
pub mut:
	dir   Direction
	pos   Position
	score int
	path  []Position
	// Add path tracking back to Node
}

struct PriorityQueue {
mut:
	items []Node
}

fn (mut pq PriorityQueue) sift_up(index int) {
	mut current := index
	for current > 0 {
		parent := (current - 1) / 2
		if pq.items[parent].score <= pq.items[current].score {
			break
		}
		pq.items[parent], pq.items[current] = pq.items[current], pq.items[parent]
		current = parent
	}
}

fn (mut pq PriorityQueue) sift_down(index int) {
	size := pq.items.len
	mut smallest := index

	for {
		left := 2 * index + 1
		right := 2 * index + 2

		if left < size && pq.items[left].score < pq.items[smallest].score {
			smallest = left
		}
		if right < size && pq.items[right].score < pq.items[smallest].score {
			smallest = right
		}
		if smallest == index {
			break
		}

		pq.items[index], pq.items[smallest] = pq.items[smallest], pq.items[index]
		smallest = index
	}
}

fn (mut pq PriorityQueue) push(item Node) {
	pq.items << item
	pq.sift_up(pq.items.len - 1)
}

fn (mut pq PriorityQueue) pop() ?Node {
	if pq.items.len == 0 {
		return none
	}

	result := pq.items[0]
	last := pq.items.pop()

	if pq.items.len > 0 {
		pq.items[0] = last
		pq.sift_down(0)
	}

	return result
}

fn apply_direction(pos Position, dir Direction) Position {
	match dir {
		.north { return Position{pos.x, pos.y - 1} }
		.east { return Position{pos.x + 1, pos.y} }
		.south { return Position{pos.x, pos.y + 1} }
		.west { return Position{pos.x - 1, pos.y} }
	}
}

fn load_map(filename string) !([][]Tile, Position, Position) {
	content := os.read_file(filename)!.split_into_lines()
	mut grid := [][]Tile{}
	mut start := Position{0, 0}
	mut finish := Position{0, 0}

	for y, line in content {
		mut row := []Tile{}
		for x, c in line {
			match c.ascii_str() {
				'S' {
					start = Position{x, y}
					row << .empty
				}
				'E' {
					finish = Position{x, y}
					row << .empty
				}
				'#' {
					row << .wall
				}
				else {
					row << .empty
				}
			}
		}
		grid << row
	}

	return grid, start, finish
}

fn encode_state(pos Position, dir Direction) u32 {
	return (u32(pos.y) << 16) | (u32(pos.x) << 8) | u32(dir)
}

fn find_path(grid [][]Tile, start Position, finish Position) (int, int) {
	mut queue := PriorityQueue{}
	mut state_cache := map[u32]int{}
	mut best_score := 9999999
	mut visited_tiles := map[string]bool{}
	mut all_best_paths := [][]Position{} // Track all paths with best score
	height := grid.len
	width := grid[0].len

	queue.push(Node{
		dir:   .east
		pos:   start
		score: 0
		path:  [start]
	})

	for {
		current := queue.pop() or { break }

		if current.pos == finish {
			if current.score <= best_score {
				if current.score < best_score {
					// New best score found, clear previous paths
					best_score = current.score
					all_best_paths.clear()
				}

				// Add this path to our collection
				all_best_paths << current.path.clone()
				continue
			}
		}

		if current.score >= best_score {
			continue
		}

		state_key := encode_state(current.pos, current.dir)
		if state_key in state_cache && state_cache[state_key] < current.score {
			continue
		}
		state_cache[state_key] = current.score

		next_dir_left := unsafe { Direction((int(current.dir) - 1 + 4) % 4) }
		next_dir_right := unsafe { Direction((int(current.dir) + 1) % 4) }

		// Helper to check and add new moves
		moves := [
			DirectionMove{current.dir, 1},
			DirectionMove{next_dir_left, 1001},
			DirectionMove{next_dir_right, 1001},
		]

		for move in moves {
			next_pos := apply_direction(current.pos, move.dir)
			if next_pos.y >= 0 && next_pos.y < height && next_pos.x >= 0 && next_pos.x < width
				&& grid[next_pos.y][next_pos.x] == .empty {
				mut new_path := current.path.clone()
				new_path << next_pos
				queue.push(Node{
					dir:   move.dir
					pos:   next_pos
					score: current.score + move.cost
					path:  new_path
				})
			}
		}
	}

	// Mark all positions from all best paths as visited
	for path in all_best_paths {
		for pos in path {
			key := '${pos.x},${pos.y}'
			visited_tiles[key] = true
		}
	}

	return best_score, visited_tiles.len
}

struct DirectionMove {
	dir  Direction
	cost int
}

fn main() {
	grid, start, finish := load_map('map.input') or { panic(err) }
	score, tile_count := find_path(grid, start, finish)
	println('part1: ${score}')
	println('part2: ${tile_count}')
}
