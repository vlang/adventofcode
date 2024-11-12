module main

import arrays
import math { abs, max, min }
import os { read_lines }
import regex { RE, regex_opt }

// https://github.com/hillerstorm/aoc2022-v/blob/main/days/day_15.v
fn main() {
	row := 10
	search_space_max := row * 2

	mut num_regex := regex_opt(r'\d+') or { panic(err) }
	sensors := read_lines('beacons.input')!.map(parse_sensor(it, mut num_regex))

	min_x := arrays.min(sensors.map(min(it.x - it.distance, it.beacon_x - it.distance)))!
	max_x := arrays.max(sensors.map(max(it.x + it.distance, it.beacon_x + it.distance)))!

	mut part_one := 0
	for x in min_x .. max_x {
		if !sensors.all(it.is_valid_beacon_position(x, row)) {
			part_one += 1
		}
	}

	mut part_two := i64(0)
	outer: for y in 0 .. search_space_max {
		for x := 0; x <= search_space_max; x += 1 {
			mut found := true
			for sensor in sensors {
				if sensor.can_see(x, y) {
					found = false

					// Shortcut to avoid looping through a grid of 1.6e+13 cells
					// Basically jump until the sensor can't see it any more
					max_x_diff := sensor.distance - abs(sensor.y - y)
					x += max_x_diff * 2 - (max_x_diff - (sensor.x - x))
				}
			}

			if found {
				part_two = i64(x) * 4000000 + y
				break outer
			}
		}
	}

	println(part_one)
	println(part_two)
}

fn (sensor &Sensor) is_valid_beacon_position(x int, y int) bool {
	return (sensor.beacon_x == x && sensor.beacon_y == y) || !sensor.can_see(x, y)
}

fn (sensor &Sensor) can_see(x int, y int) bool {
	return abs(sensor.x - x) + abs(sensor.y - y) <= sensor.distance
}

struct Sensor {
	x        int
	y        int
	beacon_x int
	beacon_y int
	distance int
}

fn parse_sensor(line string, mut num_regex RE) &Sensor {
	digits := num_regex.find_all_str(line).map(it.int())
	x, y, beacon_x, beacon_y := digits[0], digits[1], digits[2], digits[3]

	return &Sensor{
		x:        x
		y:        y
		beacon_x: beacon_x
		beacon_y: beacon_y
		distance: abs(x - beacon_x) + abs(y - beacon_y)
	}
}
