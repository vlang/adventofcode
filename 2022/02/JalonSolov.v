import os

const points = {
	'A': {
		'X': [4, 3]
		'Y': [8, 4]
		'Z': [3, 8]
	}
	'B': {
		'X': [1, 1]
		'Y': [5, 5]
		'Z': [9, 9]
	}
	'C': {
		'X': [7, 2]
		'Y': [2, 6]
		'Z': [6, 7]
	}
}

lines := os.read_lines('rock_paper_scissors.input')!

mut p0 := 0
mut p1 := 0

for l in lines {
	players := l.split(' ')
	p0 += points[players[0]][players[1]][0]
	p1 += points[players[0]][players[1]][1]
}

println('Strategy 1: ${p0}\nStrategy 2: ${p1}')
