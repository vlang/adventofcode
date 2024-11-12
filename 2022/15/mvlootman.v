module main

import os
import regex { regex_opt }
import math { abs, max }

struct Sensor {
	x        int
	y        int
	beacon_x int
	beacon_y int
	distance int
}

fn main() {
	sensors := os.read_lines('beacons.input')!
		.map(parse_sensor(it))

	part1 := solve_part1(sensors)
	part2 := solve_part2(sensors)!
	println('part 1: ${part1}\npart 2: ${part2}')
}

fn solve_part1(sensors []Sensor) int {
	min_x, max_x := get_min_max_sensor_range_x(sensors)
	mut positions_no_beacon := 0
	requested_y_pos := if sensors.len == 14 { 10 } else { 2_000_000 } // sample vs actual puzzle input
	for x in min_x .. max_x {
		if !sensors.all(pos_cannot_be_unknown_beacon(x, requested_y_pos, it)) {
			positions_no_beacon++
		}
	}
	return positions_no_beacon
}

struct Interval {
mut:
	from int
	to   int
}

fn solve_part2(sensors []Sensor) !i64 {
	max_bound := 4_000_000
	for y in 0 .. max_bound + 1 {
		mut intervals := []Interval{}
		for sensor in sensors {
			distance_to_current_y := distance(sensor.x, sensor.y, sensor.x, y)
			if distance_to_current_y <= sensor.distance {
				dist_sensor_to_y := sensor.distance - distance_to_current_y
				from := sensor.x - dist_sensor_to_y
				to := sensor.x + dist_sensor_to_y
				intervals << Interval{from, to}
			}
		}
		intervals.sort(a.from < b.from)

		// attempt merge into single interval
		for i := 1; i < intervals.len; i++ {
			if intervals[i - 1].to >= intervals[i].from {
				intervals[i - 1].to = max(intervals[i - 1].to, intervals[i].to)
				intervals.delete(i)
				i--
			}
		}

		// filter to valid (bounds)
		result := intervals.filter(it.from <= max_bound && it.to >= 0)

		if result.len > 1 {
			// there is a gap in the intervals
			x := result.first().to + 1
			assert abs(result[0].to - result[1].from) == 2
			answer := i64(x) * max_bound + y
			return answer
		}
	}
	return error('no solution found')
}

fn get_min_max_sensor_range_x(sensors []Sensor) (int, int) {
	mut min_x := sensors.first().x - sensors.first().distance
	mut max_x := sensors.first().x + sensors.first().distance
	for sensor in sensors {
		if sensor.x - sensor.distance < min_x {
			min_x = sensor.x - sensor.distance
		}
		if sensor.x + sensor.distance > max_x {
			max_x = sensor.x + sensor.distance
		}
	}
	return min_x, max_x
}

fn pos_cannot_be_unknown_beacon(x int, y int, sensor Sensor) bool {
	return !(abs(sensor.x - x) + abs(sensor.y - y) <= sensor.distance)
		|| (x == sensor.beacon_x && y == sensor.beacon_y)
}

fn parse_sensor(line string) Sensor {
	mut re := regex_opt(r'^-?\d+') or { panic(err) }
	numbers := re.find_all_str(line).map(it.int())

	return Sensor{
		x:        numbers[0]
		y:        numbers[1]
		beacon_x: numbers[2]
		beacon_y: numbers[3]
		distance: distance(numbers[0], numbers[1], numbers[2], numbers[3])
	}
}

fn distance(a_x int, a_y int, b_x int, b_y int) int {
	return abs(a_x - b_x) + abs(a_y - b_y)
}
