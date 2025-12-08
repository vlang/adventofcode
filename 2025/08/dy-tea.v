import os
import arrays

struct Point {
  x int
  y int
  z int
}

struct Pair {
  i int
  j int
  dist i64
}

struct Union {
mut:
  parent []int
  rank []int
}

fn Union.new(n int) Union {
  return Union{
    parent: []int{len: n, init: index}
    rank: []int{len: n, init: 0}
  }
}

fn (mut u Union) find(x int) int {
  if u.parent[x] != x {
    u.parent[x] = u.find(u.parent[x])
  }
  return u.parent[x]
}

fn (mut u Union) union(p Pair) bool {
  x := u.find(p.i)
  y := u.find(p.j)
  match true {
    x == y {
      return false
    }
    u.rank[x] < u.rank[y] {
      u.parent[x] = y
    }
    u.rank[x] > u.rank[y] {
      u.parent[y] = x
    }
    else {
      u.parent[y] = x
      u.rank[x]++
    }
  }
  return true
}

fn distance(p1 Point, p2 Point) i64 {
  dx := i64(p1.x - p2.x)
  dy := i64(p1.y - p2.y)
  dz := i64(p1.z - p2.z)
  return dx*dx + dy*dy + dz*dz
}

fn dfs(node int, graph map[int][]int, mut visited map[int]bool) int {
  visited[node] = true
  mut size := 1
  for neighbor in graph[node] {
    if neighbor !in visited {
      size += dfs(neighbor, graph, mut visited)
    }
  }
  return size
}

fn make_pairs(points []Point) []Pair {
  mut pairs := []Pair{}
  for i in 0..points.len {
    for j in i+1..points.len {
      dist := distance(points[i], points[j])
      pairs << Pair{
        i: i
        j: j
        dist: dist
      }
    }
  }
  return pairs.sorted(|a, b| a.dist < b.dist)
}

lines := os.read_lines('positions.input')!
points := lines.map(fn(line string) Point {
  parts := line.split(',')
  return Point{
    x: parts[0].int()
    y: parts[1].int()
    z: parts[2].int()
  }
})

// part 1
pairs := make_pairs(points)
mut graph := map[int][]int
mut u := Union.new(points.len)
max_pairs := if points.len == 20 { 10 } else { 1000 }
for idx in 0..max_pairs {
  p := pairs[idx]
  if u.union(p) {
    graph[p.i] << p.j
    graph[p.j] << p.i
  }
}
mut sizes := []int{}
mut visited := map[int]bool
for i in 0..points.len {
  if i !in visited {
    sizes << dfs(i, graph, mut visited)
  }
}
sorted_sizes := sizes.sorted(|a, b| a > b)
top3 := if sorted_sizes.len >= 3 { sorted_sizes[..3] } else { sorted_sizes }
println(arrays.fold[int, int](top3, 1, |acc, size| acc * size))

// part 2
mut last_i := 0
mut last_j := 0
for pair in pairs {
  if u.union(pair) {
    graph[pair.i] << pair.j
    graph[pair.j] << pair.i
    last_i, last_j = pair.i, pair.j
  }
}
println(points[last_i].x * points[last_j].x)
