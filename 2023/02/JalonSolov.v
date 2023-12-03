import os

const max_red = 12
const max_green = 13
const max_blue = 14

lines := os.read_lines('cube.input')!

mut sum_of_games := 0
mut sum_of_powers := 0

for l in lines {
	game_num := l[5..].int()
	draws := l[l.index(':')!+1..].split(';').map(it.trim_space())
	mut possible := true
	mut min_red := 0
	mut min_green := 0
	mut min_blue := 0

	for draw in draws {
		cubes := draw.split(',').map(it.trim_space())

		for cube in cubes {
			num_cubes := cube.int()
			cube_color := cube[cube.index(' ')!+1..]

			match cube_color {
				'red' {
					if num_cubes > max_red {
						possible = false
					}

					if num_cubes > min_red {
						min_red = num_cubes
					}
				}
				'green' {
					if num_cubes > max_green {
						possible = false
					}

					if num_cubes > min_green {
						min_green = num_cubes
					}
				}
				'blue' {
					if num_cubes > max_blue {
						possible = false
					}

					if num_cubes > min_blue {
						min_blue = num_cubes
					}
				}
				else {}
			}
		}
	}

	sum_of_games += if possible { game_num } else { 0 }
	sum_of_powers += min_red * min_green * min_blue
}

println('Part 1: ${sum_of_games}')
println('Part 2: ${sum_of_powers}')
