import os
import math

fn react_area(x1 i64, y1 i64, x2 i64, y2 i64) u64 {
	dx := math.abs(x1 - x2) + 1
	dy := math.abs(y1 - y2) + 1
	return u64(dx) * u64(dy)
}

@[flag]
enum Direction {
	x_pos
	x_neg
	y_pos
	y_neg
}

fn Direction.new(x1 u32, y1 u32, x2 u32, y2 u32) Direction {
	return match true {
		x1 == x2 && y1 < y2 { .y_pos }
		x1 == x2 && y1 > y2 { .y_neg }
		y1 == y2 && x1 < x2 { .x_pos }
		else { .x_neg }
	}
}

struct DirectedPoint {
	x u32
	y u32
	e u32
	d Direction
}

fn DirectedPoint.new(x1 u32, y1 u32, x2 u32, y2 u32) DirectedPoint {
	dx := if x2 > x1 { x2 - x1 } else { x1 - x2 }
	dy := if y2 > y1 { y2 - y1 } else { y1 - y2 }
	return DirectedPoint{
		x: x1
		y: y1
		e: math.max(dx, dy)
		d: Direction.new(x1, y1, x2, y2)
	}
}

fn (dp DirectedPoint) extent_overlaps(x1 u32, y1 u32, x2 u32, y2 u32) bool {
	rx_min := math.min(x1, x2)
	rx_max := math.max(x1, x2)
	ry_min := math.min(y1, y2)
	ry_max := math.max(y1, y2)

	ro_min, ro_max := match dp.d {
		.x_neg { dp.x - dp.e, dp.x }
		.x_pos { dp.x, dp.x + dp.e }
		.y_neg { dp.y - dp.e, dp.y }
		.y_pos { dp.y, dp.y + dp.e }
		else { u32(0), u32(0) }
	}

	return match dp.d {
		.x_neg, .x_pos {
			rx_min < ro_max && ro_min < rx_max
		}
		.y_neg, .y_pos {
			ry_min < ro_max && ro_min < ry_max
		}
		else {
			false
		}
	}
}

fn is_red_inside(points []DirectedPoint, x1 u32, y1 u32, x2 u32, y2 u32, xs u32, xe u32, ys u32, ye u32) bool {
	return points.filter(fn [x1, x2, y1, y2] (p DirectedPoint) bool {
		return p.x != x1 && p.x != x2 && p.y != y1 && p.y != y2
	}).any(fn [xs, xe, ys, ye] (p DirectedPoint) bool {
		return xs <= p.x && p.x <= xe && ys <= p.y && p.y <= ye
	})
}

fn valid_area(points []DirectedPoint, x1 u32, y1 u32, x2 u32, y2 u32) ?u64 {
	minx := math.min(x1, x2)
	maxx := math.max(x1, x2)
	miny := math.min(y1, y2)
	maxy := math.max(y1, y2)

	if is_red_inside(points, x1, y1, x2, y2, minx, maxx, miny, maxy) {
		return none
	}

	region_x_min := minx + 1
	region_x_max := maxx
	region_y_min := miny + 1
	region_y_max := maxy

	if points.filter(fn [region_x_min, region_x_max, region_y_min, region_y_max] (p DirectedPoint) bool {
		return (region_x_min <= p.x && p.x < region_x_max && (p.d == .y_pos || p.d == .y_neg))
			|| (region_y_min <= p.y && p.y < region_y_max && (p.d == .x_pos || p.d == .x_neg))
	}).any(fn [x1, y1, x2, y2] (p DirectedPoint) bool {
		return p.extent_overlaps(x1, y1, x2, y2)
	})
	{
		return none
	}

	dx := if x2 > x1 { x2 - x1 } else { x1 - x2 }
	dy := if y2 > y1 { y2 - y1 } else { y1 - y2 }
	return u64(dx + 1) * u64(dy + 1)
}

lines := os.read_lines('tiles.input')!
coords := lines.map(fn (line string) []i64 {
	x, y := line.split_once(',') or { panic('invalid input') }
	return [x.i64(), y.i64()]
})

// part 1
mut max_area := u64(0)
for i := 0; i < coords.len - 1; i++ {
	x, y := coords[i][0], coords[i][1]
	for j := i + 1; j < coords.len; j++ {
		xx, yy := coords[j][0], coords[j][1]
		area := react_area(x, y, xx, yy)
		if area > max_area {
			max_area = area
		}
	}
}
println(max_area)

// part 2
red_tiles := coords.map(fn (c []i64) []u32 {
	return [u32(c[0]), u32(c[1])]
})
mut tiles_with_directions := []DirectedPoint{cap: red_tiles.len}
for i := 0; i < red_tiles.len; i++ {
	next_i := (i + 1) % red_tiles.len
	p1 := red_tiles[i]
	p2 := red_tiles[next_i]
	tiles_with_directions << DirectedPoint.new(p1[0], p1[1], p2[0], p2[1])
}
max_area = 0
for i := 0; i < red_tiles.len - 1; i++ {
	p1 := red_tiles[i]
	for j := i + 1; j < red_tiles.len; j++ {
		p2 := red_tiles[j]
		if area := valid_area(tiles_with_directions, p1[0], p1[1], p2[0], p2[1]) {
			if area > max_area {
				max_area = area
			}
		}
	}
}
println(max_area)
