import os { read_file }
import arrays { fold }

interface Cyclable {
mut:
	cycle int
	register_x int
	run_cycle()
}

fn (mut c Cyclable) run_instruction(instruction string) Cyclable {
	instruction_segment := instruction.split(' ')

	match instruction_segment[0] {
		'noop' {
			c.run_cycle()
		}
		'addx' {
			c.run_cycle()
			c.run_cycle()
			c.register_x += instruction_segment[1].int()
		}
		else {}
	}

	return *c
}

struct CycleState {
mut:
	cycle      int
	register_x int = 1
	signal_sum int
}

fn (mut state CycleState) run_cycle() {
	state.cycle++
	if state.cycle == 20 || (state.cycle - 20) % 40 == 0 {
		state.signal_sum += state.cycle * state.register_x
	}
}

struct CrtState {
mut:
	cycle      int
	register_x int      = 1
	crt_image  []string = []
}

fn (mut state CrtState) run_cycle() {
	state.crt_image << if state.cycle >= state.register_x - 1 && state.cycle <= state.register_x + 1 {
		'.'
	} else {
		'#'
	}
	state.cycle++
	if state.cycle % 40 == 0 {
		state.cycle = 0
		state.crt_image << '\n'
	}
}

fn main() {
	data := read_file('crt.input')!.replace('\r\n', '\n').split('\n')

	println(part1(data))
	println(part2(data))
}

fn part1(data []string) int {
	state := run_state(data, CycleState{})
	return if state is CycleState {
		state.signal_sum
	} else {
		0
	}
}

fn part2(data []string) string {
	state := run_state(data, CrtState{})
	return if state is CrtState {
		state.crt_image.join('')
	} else {
		''
	}
}

fn run_state(data []string, cyclable Cyclable) Cyclable {
	return fold(data, cyclable, fn (state Cyclable, instruction string) Cyclable {
		mut new_state := state
		return new_state.run_instruction(instruction)
	})
}
