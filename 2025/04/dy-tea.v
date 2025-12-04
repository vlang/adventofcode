import os

lines := os.read_lines('department.input')!
offsets := [[-1, -1], [0, -1], [-1, 0], [1, 1], [1, 0], [0, 1],
	[1, -1], [-1, 1]]

// part 1
mut sum := 0
for x, line in lines {
	iter: for y, ch in line {
		if ch == `.` {
			continue
		}
		mut count := 0
		for pos in offsets {
			nx := x + pos[0]
			ny := y + pos[1]
			if nx < 0 || nx >= line.len || ny < 0 || ny >= lines.len {
				continue
			}
			if lines[nx][ny] == `@` {
				count++
			}
			if count > 3 {
				continue iter
			}
		}
		sum++
	}
}
println(sum)

// part 2
sum = 0
mut grid := lines.map(|l| l.runes())
mut removed := 1
for removed != 0 {
	removed = 0
	for x, row in grid {
		loop: for y, ch in row {
			if ch == `.` {
				continue
			}
			mut count := 0
			for pos in offsets {
				nx := x + pos[0]
				ny := y + pos[1]
				if nx < 0 || nx >= row.len || ny < 0 || ny >= grid.len {
					continue
				}
				if grid[nx][ny] == `@` {
					count++
				}
				if count > 3 {
					continue loop
				}
			}
			grid[x][y] = `.`
			removed++
			sum++
		}
	}
}
println(sum)
