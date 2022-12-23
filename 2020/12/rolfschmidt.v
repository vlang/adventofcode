// $origin: https://github.com/rolfschmidt/advent-of-code

module main

import os

fn d12_moved(a int, b int, number int) (int, int) {
	mut ra := a
	mut rb := b
	mut rn := number
	for rn > 0 && rb > 0 {
		rn--
		rb--
	}
	for rn > 0 {
		rn--
		ra++
	}
	return ra, rb
}

fn d12_rd(d string) string {
	mut rd := map[string]string{}
	rd['n'] = 'e'
	rd['e'] = 's'
	rd['s'] = 'w'
	rd['w'] = 'n'
	return rd[d]
}

fn d12_ld(d string) string {
	mut ld := map[string]string{}
	ld['n'] = 'w'
	ld['w'] = 's'
	ld['s'] = 'e'
	ld['e'] = 'n'
	return ld[d]
}

fn day12a() int {
	mut lines := read_day('12.input')
	mut n := 0
	mut e := 0
	mut s := 0
	mut w := 0
	mut d := 'e'
	for line in lines {
		command := line[0]
		mut number := line[1..].int()
		match command {
			`N` {
				n, s = d12_moved(n, s, number)
			}
			`S` {
				s, n = d12_moved(s, n, number)
			}
			`E` {
				e, w = d12_moved(e, w, number)
			}
			`W` {
				w, e = d12_moved(w, e, number)
			}
			`L` {
				for i := 0; i < number / 90; i++ {
					d = d12_ld(d)
				}
			}
			`R` {
				for i := 0; i < number / 90; i++ {
					d = d12_rd(d)
				}
			}
			`F` {
				if d == 'n' {
					n, s = d12_moved(n, s, number)
				} else if d == 'e' {
					e, w = d12_moved(e, w, number)
				} else if d == 's' {
					s, n = d12_moved(s, n, number)
				} else if d == 'w' {
					w, e = d12_moved(w, e, number)
				}
			}
			else {
				break
			}
		}
	}
	return n + e + s + w
}

fn day12b() int {
	mut lines := read_day('12.input')
	mut n := 0
	mut e := 0
	mut s := 0
	mut w := 0
	mut wp := map[string]int{}
	wp['n'] = 1
	wp['e'] = 10
	wp['s'] = 0
	wp['w'] = 0
	for line in lines {
		command := line[0]
		mut number := line[1..].int()
		match command {
			`N` {
				wp['n'], wp['s'] = d12_moved(wp['n'], wp['s'], number)
			}
			`S` {
				wp['s'], wp['n'] = d12_moved(wp['s'], wp['n'], number)
			}
			`E` {
				wp['e'], wp['w'] = d12_moved(wp['e'], wp['w'], number)
			}
			`W` {
				wp['w'], wp['e'] = d12_moved(wp['w'], wp['e'], number)
			}
			`L` {
				for i := 0; i < number / 90; i++ {
					wpn := wp[d12_rd('n')]
					wpe := wp[d12_rd('e')]
					wps := wp[d12_rd('s')]
					wpw := wp[d12_rd('w')]
					wp['n'] = wpn
					wp['e'] = wpe
					wp['s'] = wps
					wp['w'] = wpw
				}
			}
			`R` {
				for i := 0; i < number / 90; i++ {
					wpn := wp[d12_ld('n')]
					wpe := wp[d12_ld('e')]
					wps := wp[d12_ld('s')]
					wpw := wp[d12_ld('w')]
					wp['n'] = wpn
					wp['e'] = wpe
					wp['s'] = wps
					wp['w'] = wpw
				}
			}
			`F` {
				n, s = d12_moved(n, s, number * wp['n'])
				e, w = d12_moved(e, w, number * wp['e'])
				s, n = d12_moved(s, n, number * wp['s'])
				w, e = d12_moved(w, e, number * wp['w'])
			}
			else {
				break
			}
		}
	}
	return n + e + s + w
}

fn main() {
	println(day12a())
	println(day12b())
}

fn read_day_string(path string) string {
	mut data := os.read_file(path) or { panic(err) }
	return data.trim(' \n\t\v\f\r')
}

fn read_day(path string) []string {
	return read_day_string(path).split_into_lines()
}
