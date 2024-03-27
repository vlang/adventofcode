module main

import os
import math
import arrays

fn main() {
	input_path := 'mirage_maintenance.input'

	lines := os.read_lines(input_path) or { panic('Could not read input file.') }
	mut sum := 0
	sequences := get_sequences(lines)
	for sequence in sequences {
		sum += extrapolate(sequence)
	}
	println('Final result: ${sum}')
}

fn get_sequences(lines []string) [][]int {
	mut result := [][]int{}
	for line in lines {
		result << line.split(' ').map(fn (s string) int {
			return s.int()
		})
	}
	return result
}

fn all_zeroes(sequence []int) bool {
	return arrays.sum(sequence.map(fn (x int) int {
		return math.abs(x)
	})) or { panic('Could not check if all elements of ${sequence} were 0.') } == 0
}

// Given a sequence, finds the next number
fn extrapolate(sequence []int) int {
	dif := get_all_differences(sequence)
	// first is the reversed list of first elements in the differences list
	first := []int{len: dif.len - 1, init: dif[index][0]}.reverse()
	mut res := first[0]
	for i in 1 .. first.len {
		res = first[i] - res
	}
	return res
}

// Return the list of all differences of the sequence
fn get_all_differences(sequence []int) [][]int {
	mut res := [][]int{}
	res << sequence
	for {
		dif := differences(res[res.len - 1])
		res << dif
		if all_zeroes(dif) {
			return res
		}
	}
	return res
}

// Given a sequence, returns the sequence of differences
fn differences(sequence []int) []int {
	return []int{len: sequence.len - 1, init: sequence[index + 1] - sequence[index]}
}
