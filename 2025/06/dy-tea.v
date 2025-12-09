import os
import regex as re
import arrays

mut multiple_spaces := re.regex_opt(' +')!
file := os.read_file('worksheet.input')!.split_any('\n\r')
mut lines := [][]string{}
for line in file {
	lines << multiple_spaces.split(line).filter(|s| s != '')
}
ops := lines.last()

// part 1
mut sum := u64(0)
for i in 0 .. ops.len {
	mut tmp := lines[0][i].u64()
	if ops[i] == '+' {
		for j in 1 .. lines.len - 1 {
			tmp += lines[j][i].u64()
		}
	} else {
		for j in 1 .. lines.len - 1 {
			tmp *= lines[j][i].u64()
		}
	}
	sum += tmp
}
println(sum)

// part 2
sum = 0
file_last := file.last()
mut digits := []u64{}
for j := file_last.len - 1; j >= 0; j-- {
	curr := file_last[j]
	mut st := ''
	for i in 0 .. file.len - 1 {
		st += file[i][j].ascii_str()
	}
	dig := st.replace(' ', '').u64()
	if dig != 0 {
		digits << dig
	}
	if curr != ` ` {
		if curr == `+` {
			sum += arrays.sum[u64](digits)!
		} else {
			sum += arrays.fold[u64, u64](digits, 1, |acc, elem| acc * elem)
		}
		digits.clear()
	}
}
println(sum)
