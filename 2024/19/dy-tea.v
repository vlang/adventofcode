import os

const input_file = 'towels.input'

fn possible(towels []string, current string, query string, mut visited map[string]bool) bool {
	if current == query {
		return true
	}

	if current.len >= query.len {
		return false
	}

	if visited[current] {
		return false
	}

	visited[current] = true

	for towel in towels {
		n := current + towel

		if query == n {
			return true
		}

		if query.starts_with(n) {
			if possible(towels, n, query, mut visited) {
				return true
			}
		}
	}

	return false
}

fn count_combinations(towels []string, current string, query string, mut visited map[string]u64) u64 {
	if current == query {
		return 1
	}

	if current.len >= query.len {
		return 0
	}

	if current in visited {
		return visited[current]
	}

	mut sum := u64(0)

	for towel in towels {
		n := current + towel

		if query.starts_with(n) {
			sum += count_combinations(towels, n, query, mut visited)
		}
	}

	visited[current] = sum
	return sum
}

fn p1(input string) ! {
	lines := os.read_lines(input)!

	towels := lines[0].split(', ')
	queries := lines[2..]

	mut sum := 0
	for query in queries {
		mut visited := map[string]bool{}
		sum += if possible(towels, '', query, mut visited) { 1 } else { 0 }
	}

	println(sum)
}

fn p2(input string) ! {
	lines := os.read_lines(input)!

	towels := lines[0].split(', ')
	queries := lines[2..]

	mut sum := u64(0)
	for query in queries {
		mut visited := map[string]u64{}
		sum += count_combinations(towels, '', query, mut visited)
	}

	println(sum)
}

fn main() {
	p1(input_file)!
	p2(input_file)!
}
