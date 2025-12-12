import os

fn count_paths(graph map[string][]string, current string, end string, waypoints []string, path []string, mut memo map[string]i64) i64 {
	mut visited := []string{}
	for wp in waypoints {
		if wp in path {
			visited << wp
		}
	}
	key := '${current}:${visited.join(',')}'
	if key in memo {
		return memo[key]
	}
	if current == end {
		result := if visited.len == waypoints.len { 1 } else { 0 }
		memo[key] = result
		return result
	}
	mut count := i64(0)
	for neighbor in graph[current] {
		if neighbor !in path {
			mut new_path := path.clone()
			new_path << neighbor
			count += count_paths(graph, neighbor, end, waypoints, new_path, mut memo)
		}
	}
	memo[key] = count
	return count
}

lines := os.read_lines('connections_part1.input')!
mut graph := map[string][]string{}
for line in lines {
	graph[line[..3]] = line[5..].split(' ')
}

// part 1
mut count := 0
mut stack := ['you']
for stack.len > 0 {
	node := stack.pop()
	for neighbor in graph[node] {
		if neighbor == 'out' {
			count++
		} else {
			stack << neighbor
		}
	}
}
println(count)

// part 2
lines2 := os.read_lines('connections_part2.input')!
graph.clear()
for line in lines2 {
	graph[line[..3]] = line[5..].split(' ')
}
mut memo := map[string]i64{}
println(count_paths(graph, 'svr', 'out', ['dac', 'fft'], ['svr'], mut memo))
