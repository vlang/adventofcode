// $origin: https://github.com/rolfschmidt/advent-of-code

module main

import os

@[inline]
fn d17_run(part2 bool) int {
	mut lines := read_day('17.input')
	mut cubes := map[string]bool{}
	for y, line in lines {
		for x, row in line.split('') {
			if row == '#' {
				cubes['${x}_${y}_0_0'] = true
			}
		}
	}
	mut swmin := 0
	mut swmax := 1
	if part2 {
		swmin = -1
		swmax = 2
	}
	mut total := 0
	for _ in 0 .. 6 {
		mut ch := []string{}
		mut xmin := 0
		mut ymin := 0
		mut zmin := 0
		mut wmin := 0
		mut xmax := 0
		mut ymax := 0
		mut zmax := 0
		mut wmax := 1
		for c in cubes.keys() {
			cs := c.split('_').map(it.int())
			xmin = int_min(cs[0], xmin)
			ymin = int_min(cs[1], ymin)
			zmin = int_min(cs[2], zmin)
			xmax = int_max(cs[0], xmax)
			ymax = int_max(cs[1], ymax)
			zmax = int_max(cs[2], zmax)
			if part2 {
				wmin = int_min(cs[3], wmin)
				wmax = int_max(cs[3], wmax)
			}
		}
		xmin--
		ymin--
		zmin--
		xmax += 2
		ymax += 2
		zmax += 2
		if part2 {
			wmin--
			wmax += 2
		}
		for x in xmin .. xmax {
			for y in ymin .. ymax {
				for z in zmin .. zmax {
					for w in wmin .. wmax {
						mut c := cubes['${x}_${y}_${z}_${w}']
						mut nc := 0
						for sx in -1 .. 2 {
							for sy in -1 .. 2 {
								for sz in -1 .. 2 {
									for sw in swmin .. swmax {
										if sx == 0 && sy == 0 && sz == 0 && sw == 0 {
											continue
										}
										if !cubes['${sx + x}_${sy + y}_${sz + z}_${sw + w}'] {
											continue
										}
										nc++
									}
								}
							}
						}
						if nc >= 2 && nc <= 3 && c {
							ch << '${x}_${y}_${z}_${w}'
						} else if nc == 3 && !c {
							ch << '${x}_${y}_${z}_${w}'
						}
					}
				}
			}
		}
		total = 0
		cubes = map[string]bool{}
		for e in ch {
			cubes[e] = true
			total++
		}
	}
	return total
}

fn day17a() int {
	return d17_run(false)
}

fn day17b() int {
	return d17_run(true)
}

fn main() {
	println(day17a())
	println(day17b())
}

fn read_day_string(path string) string {
	mut data := os.read_file(path) or { panic(err) }
	return data.trim(' \n\t\v\f\r')
}

fn read_day(path string) []string {
	return read_day_string(path).split_into_lines()
}
