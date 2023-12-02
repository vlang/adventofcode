import os

fn find_marker(input string, window_size int) ?int {
	mut frequencies := [256]u8{}
	mut unique_chars := 0

	for i in 0 .. window_size {
		c := input[i]
		if frequencies[c] == 0 {
			unique_chars++
		}
		frequencies[c]++
	}
	// check if the first window is a valid solution
	if unique_chars == window_size {
		return window_size
	}
	for i := window_size; i < input.len; i++ {
		// abcde
		// ^---  the previous window  ^ = head
		//  ---^ the new window       ^ = tail
		head, tail := input[i - window_size], input[i]

		if head == tail {
			// a...a
			// this window is identical to the previous, so we can skip this iteration
			continue
		}

		if frequencies[head] == 1 {
			unique_chars--
		}
		if frequencies[tail] == 0 {
			unique_chars++
		}
		frequencies[head]--
		frequencies[tail]++

		if unique_chars == window_size {
			return i + 1
		}
	}
	return none
}

input := os.read_file('datastream.input')!
println(find_marker(input, 4)?)
println(find_marker(input, 14)?)
