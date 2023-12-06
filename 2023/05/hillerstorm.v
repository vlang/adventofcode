module main

import arrays
import math
import os

struct Range {
	start  u64
	length u64
}

struct RangeMap {
	source_start u64
	dest_start   u64
	length       u64
}

struct RangeMaps {
	seed_to_soil            []&RangeMap
	soil_to_fertilizer      []&RangeMap
	fertilizer_to_water     []&RangeMap
	water_to_light          []&RangeMap
	light_to_temperature    []&RangeMap
	temperature_to_humidity []&RangeMap
	humidity_to_location    []&RangeMap
}

fn main() {
	parts := os.read_file('seed_map.input')!.split('\n\n')
	seeds := parts[0].split(': ')[1].split(' ').map(it.u64())
	range_maps := RangeMaps{
		seed_to_soil: map_ranges(parts[1])
		soil_to_fertilizer: map_ranges(parts[2])
		fertilizer_to_water: map_ranges(parts[3])
		water_to_light: map_ranges(parts[4])
		light_to_temperature: map_ranges(parts[5])
		temperature_to_humidity: map_ranges(parts[6])
		humidity_to_location: map_ranges(parts[7])
	}

	part_one := solve(seeds.map(&Range{it, 1}), range_maps)!
	part_two := solve(arrays.chunk(seeds, 2).map(&Range{it[0], it[1]}), range_maps)!

	println('Part 1: ${part_one}')
	println('Part 2: ${part_two}')
}

fn solve(seed_ranges []&Range, range_maps &RangeMaps) !u64 {
	mut result := max_u64
	for seed_range in seed_ranges {
		soil_range := find_mapped_value([seed_range], range_maps.seed_to_soil)
		fertilizer_range := find_mapped_value(soil_range, range_maps.soil_to_fertilizer)
		water_range := find_mapped_value(fertilizer_range, range_maps.fertilizer_to_water)
		light_range := find_mapped_value(water_range, range_maps.water_to_light)
		temperature_range := find_mapped_value(light_range, range_maps.light_to_temperature)
		humidity_range := find_mapped_value(temperature_range, range_maps.temperature_to_humidity)
		location_range := find_mapped_value(humidity_range, range_maps.humidity_to_location)

		result = math.min(result, arrays.min(location_range.map(it.start))!)
	}

	return result
}

fn find_mapped_value(value []&Range, ranges []&RangeMap) []&Range {
	mut result := []&Range{}
	mut queue := value.clone()

	for queue.len > 0 {
		value_range := queue.pop()

		mut found := false
		for range in ranges {
			if value_range.start >= range.source_start
				&& value_range.start + value_range.length <= range.source_start + range.length {
				// value falls completely within range
				result << &Range{
					start: range.dest_start + value_range.start - range.source_start
					length: value_range.length
				}

				found = true
				break
			} else if value_range.start >= range.source_start
				&& value_range.start < range.source_start + range.length {
				// value starts within range but ends outside of it
				result << &Range{
					start: range.dest_start + value_range.start - range.source_start
					length: range.source_start + range.length - value_range.start
				}
				queue << &Range{
					start: range.source_start + range.length
					length: value_range.length - (range.source_start + range.length - value_range.start)
				}

				found = true
				break
			} else if value_range.start < range.source_start
				&& value_range.start + value_range.length > range.source_start {
				// value starts before the range but ends within it
				queue << &Range{
					start: value_range.start
					length: range.source_start - value_range.start
				}
				result << &Range{
					start: range.dest_start
					length: value_range.length - (range.source_start - value_range.start)
				}

				found = true
				break
			} else if value_range.start < range.source_start
				&& value_range.start + value_range.length >= range.source_start + range.length {
				// value starts before the range and ends after it
				queue << &Range{
					start: value_range.start
					length: range.source_start - value_range.start
				}
				result << &Range{
					start: range.dest_start
					length: range.length
				}
				queue << &Range{
					start: range.source_start + range.length
					length: value_range.start + value_range.length - range.length
				}

				found = true
				break
			}
		}

		if !found {
			// value is not within any range, maps to itself
			result << value_range
		}
	}

	return result
}

fn map_ranges(value string) []&RangeMap {
	return value.split_into_lines()[1..].map(map_range(it.split(' ').map(it.u64())))
}

fn map_range(values []u64) &RangeMap {
	return &RangeMap{
		source_start: values[1]
		dest_start: values[0]
		length: values[2]
	}
}
