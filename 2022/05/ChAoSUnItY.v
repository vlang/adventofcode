import os { read_file }
import arrays { chunk }
import regex { new }
import datatypes { DoublyLinkedList }

const digit_r = r'\d+'

struct ParseResult {
	stacks       []DoublyLinkedList[u8]
	instructions []Instruction
}

struct Instruction {
	count int
	from  int
	to    int
}

fn main() {
	data := read_file('supplystacks.input')!

	println(part1(process_data(data))!)
	println(part2(process_data(data))!)
}

fn part1(data ParseResult) !string {
	mut stack := data.stacks.clone()

	for instruction in data.instructions {
		for _ in 0 .. instruction.count {
			popped := stack[instruction.from - 1].pop_front() or { 0 }
			stack[instruction.to - 1].push_front(popped)
		}
	}

	return stack.map(it.first() or { 0 }).bytestr()
}

fn part2(data ParseResult) !string {
	mut stack := data.stacks.clone()

	for instruction in data.instructions {
		mut popped := DoublyLinkedList[u8]{}

		for _ in 0 .. instruction.count {
			popped.push_front(stack[instruction.from - 1].pop_front() or { 0 })
		}

		for element in popped {
			stack[instruction.to - 1].push_front(element)
		}
	}

	return stack.map(it.first() or { 0 }).bytestr()
}

fn process_data(data string) ParseResult {
	split_data := data.replace('\r\n', '\n').split('\n\n')
	return ParseResult{process_stack(split_data[0]), process_instructions(split_data[1])}
}

fn process_stack(data string) []DoublyLinkedList[u8] {
	splitted_data := data.split('\n')#[..-1]
	stack_size := (splitted_data[0].len + 1) / 4
	mut stacks := []DoublyLinkedList[u8]{len: stack_size, init: DoublyLinkedList[u8]{}}

	for line in splitted_data {
		for i, element in chunk(line.bytes(), 4) {
			if element.all(it == 32) {
				continue
			}

			stacks[i].push_back(element[1])
		}
	}

	return stacks
}

fn process_instructions(data string) []Instruction {
	mut instructions := []Instruction{}

	for line in data.split('\n') {
		mut digit_regex := new()
		digit_regex.compile_opt(digit_r) or { return instructions }
		digits := digit_regex.find_all_str(line).map(it.int())

		instructions << Instruction{digits[0], digits[1], digits[2]}
	}

	return instructions
}
