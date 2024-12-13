import os
import arrays

struct Point {
pub mut:
	x i64 @[required]
	y i64 @[required]
}

fn (p Point) equals(other Point) bool {
	return p.x == other.x && p.y == other.y
}

struct Machine {
	a Point
	b Point
	t Point
}

fn parse_button(button string) Point {
	split := button.split(', ')
	x := i64(split[0].split('+')[1].int())
	y := i64(split[1].split('+')[1].int())
	return Point{
		x: x
		y: y
	}
}

fn parse_target(target string) Point {
	split := target.split(', ')
	x := i64(split[0].split('=')[1].int())
	y := i64(split[1].split('=')[1].int())
	return Point{
		x: x
		y: y
	}
}

fn determinant(a i64, b i64, c i64, d i64) i64 {
	return a * d - b * c
}

fn cramers_rule(a i64, b i64, c i64, d i64, e i64, f i64) ?[2]i64 {
	det := determinant(a, b, c, d)

	if det == 0 {
		return none
	}

	det_x := determinant(e, b, f, d)
	det_y := determinant(a, e, c, f)
	return [det_x / det, det_y / det]!
}

fn solve(machine Machine) ?[2]i64 {
	result := cramers_rule(machine.a.x, machine.b.x, machine.a.y, machine.b.y, machine.t.x,
		machine.t.y)

	if result != none {
		result_point := Point{
			x: result[0] * machine.a.x + result[1] * machine.b.x
			y: result[0] * machine.a.y + result[1] * machine.b.y
		}
		if result_point.equals(machine.t) {
			return [result[0], result[1]]!
		}
	}
	return none
}

fn main() {
	machines := arrays.chunk(os.read_file('machines.input')!.split_into_lines().filter(it != ''),
		3).map(fn (machine []string) Machine {
		return Machine{
			a: parse_button(machine[0])
			b: parse_button(machine[1])
			t: parse_target(machine[2])
		}
	})

	mut tokens1 := i64(0)
	for machine in machines {
		result := solve(machine)
		if result != none {
			tokens1 += ((result[0] * 3) + result[1])
		}
	}
	println('part1: ${tokens1}')

	mut tokens2 := i64(0)
	for machine in machines {
		new_target := Point{
			x: machine.t.x + 10000000000000
			y: machine.t.y + 10000000000000
		}
		new_machine := Machine{
			a: machine.a
			b: machine.b
			t: new_target
		}

		result := solve(new_machine)
		if result != none {
			tokens2 += ((result[0] * 3) + result[1])
		}
	}
	println('part2: ${tokens2}')
}
