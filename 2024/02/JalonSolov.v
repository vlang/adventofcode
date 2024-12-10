import math
import os

lines := os.read_lines('reports.input')!

mut safe_reports := 0
mut dampened_safe_reports := 0
mut val := 0
mut abs_val := 0

for line in lines {
	mut all_safe := true
	mut bad_levels := 0
	reps := line.split(' ').map(it.int())

	mut desc := (reps[0] - reps[1]) > 0

	for level_idx in 0 .. reps.len - 1 {
		val = reps[level_idx] - reps[level_idx + 1]
		abs_val = math.abs(val)
		if (val > 0) != desc || abs_val < 1 || abs_val > 3 {
			all_safe = false
			bad_levels++
			match level_idx {
				// if the first problem was at the start of the line,
				// re-do the `desc` var in case the direction changes
				0 {
					desc = (reps[1] - reps[2]) > 0
					continue
				}
				// if the first problem is the 2nd level, recalculate
				// desc starting from here, just in case
				1 {
					desc = (reps[1] - reps[2]) > 0
				}
				// if the problem was on the last 2 levels, no need
				// to worry about anything else - if that was the only
				// problem, we still have a dampened report
				reps.len - 2 {
					break
				}
				// otherwise, try checking around the error point
				else {
					desc = (reps[level_idx - 1] - reps[level_idx + 1]) > 0
					val = reps[level_idx - 1] - reps[level_idx + 1]
					abs_val = math.abs(val)
					if (val > 0) != desc || abs_val < 1 || abs_val > 3 {
						bad_levels++
						break
					}
				}
			}
		}
	}

	if all_safe == true {
		safe_reports++
	}

	if bad_levels < 2 {
		dampened_safe_reports++
	}
}

println('Part 1: ${safe_reports}')
println('Part 2: ${dampened_safe_reports}')
