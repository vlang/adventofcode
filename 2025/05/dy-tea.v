import os
import arrays

lines := os.read_lines('ingredients.input')!
mut sep_idx := 0
for i, line in lines {
	if line == '' {
		sep_idx = i
		break
	}
}
ranges := lines[..sep_idx].map(fn (x string) []u64 {
	left, right := x.split_once('-') or { panic('invalid input') }
	return [left.u64(), right.u64()]
})
available := lines[sep_idx + 1..].map(|x| x.u64())

// part 1
mut sum := u64(0)
for id in available {
	for rn in ranges {
		left, right := rn[0], rn[1]
		if id >= left && id <= right {
			sum++
			break
		}
	}
}
println(sum)

// part 2
mut merged := [][]u64{}
for rn in ranges {
	mut nl := rn[0]
	mut nr := rn[1]
	mut removed := []int{}
	for i, ex in merged {
		el, er := ex[0], ex[1]
		if nl <= er + 1 && nr >= el - 1 {
			nl = if nl < el { nl } else { el }
			nr = if nr > er { nr } else { er }
			removed << i
		}
	}
	for i := removed.len - 1; i >= 0; i-- {
		merged.delete(removed[i])
	}
	merged << [nl, nr]
}
sum = arrays.sum(merged.map(|arr| arr[1] - arr[0] + 1))!
println(sum)
