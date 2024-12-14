import os

struct Position {
pub mut:
	x i64 @[required]
	y i64 @[required]
}

struct Velocity {
pub mut:
	x i64 @[required]
	y i64 @[required]
}

struct Robot {
pub mut:
	position Position @[required]
	velocity Velocity @[required]
}

const width = 101
const height = 103

fn main() {
	mut robots := os.read_file('robots.input')!.split_into_lines().map(fn (line string) Robot {
		split := line.split(' ')
		position := Position{
			x: i64(split[0].split(',')[0].split('=')[1].int())
			y: i64(split[0].split(',')[1].int())
		}
		velocity := Velocity{
			x: i64(split[1].split(',')[0].split('=')[1].int())
			y: i64(split[1].split(',')[1].int())
		}
		return Robot{
			position: position
			velocity: velocity
		}
	})

	// simulate all robots for 100 seconds
	mut robots1 := robots.clone()
	for _ in 0 .. 100 {
		// apply velocity to all robots and if we hit the edge we teleport to the other side
		for mut robot in robots1 {
			robot.position.x += robot.velocity.x
			robot.position.y += robot.velocity.y
			robot.position.x = (robot.position.x + width) % width
			robot.position.y = (robot.position.y + height) % height
		}
	}

	// To determine the safest area, count the number of robots in each quadrant after 100 seconds. Robots that are exactly in the middle (horizontally or vertically) don't count as being in any quadrant, so the only relevant robots are:
	mut quadrants := [4]i64{}
	for robot in robots1 {
		if robot.position.x == width / 2 || robot.position.y == height / 2 {
			continue
		}
		if robot.position.x < width / 2 {
			if robot.position.y < height / 2 {
				quadrants[0] += 1
			} else {
				quadrants[1] += 1
			}
		} else {
			if robot.position.y < height / 2 {
				quadrants[2] += 1
			} else {
				quadrants[3] += 1
			}
		}
	}

	mut result1 := quadrants[0] * quadrants[1] * quadrants[2] * quadrants[3]
	println('part1: ${result1}')

	// simulate all robots for 100 seconds
	mut robots2 := robots.clone()
	mut i := 1
	for {
		// apply velocity to all robots and if we hit the edge we teleport to the other side
		for mut robot in robots2 {
			robot.position.x += robot.velocity.x
			robot.position.y += robot.velocity.y
			robot.position.x = (robot.position.x + width) % width
			robot.position.y = (robot.position.y + height) % height
		}

		mut positions := []Position{}
		mut unique := true
		for robot in robots2 {
			if robot.position in positions {
				unique = false
				break
			}
			positions << robot.position
		}
		if unique {
			target_length := 5
			mut length := 0
			for position in positions {
				mut current_position := position
				for positions.contains(current_position) {
					length += 1

					if length == target_length {
						break
					}

					current_position.x += 1
				}

				if length == target_length {
					break
				}

				length = 0
			}

			if length == target_length {
				break
			}
		}
		i += 1
	}

	println('part2: ${i}')
}
