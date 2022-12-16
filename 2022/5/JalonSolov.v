import os

lines := os.read_lines('supplystacks.input')!

mut commands := false // false == parsing crates, true == parsing commands
mut stacks := map[int][]byte{}
mut stacks2 := map[int][]byte{}
mut src := 0
mut dest := 0
mut count := 0
mut tmpstack := []byte{}

for l in lines {
	if l == '' {
		commands = true
		continue
	}

	if commands {
		count = l[5..].int()
		src = l[11 + count.str().len..].int() - 1
		dest = l[15 + count.str().len + src.str().len..].int() - 1

		for i in 0 .. count {
			stacks[dest].insert(0, stacks[src][i])
		}
		stacks[src] = stacks[src][count..]

		tmpstack = stacks2[src][..count]
		tmpstack << stacks2[dest]
		stacks2[dest] = tmpstack
		stacks2[src] = stacks2[src][count..]
	} else {
		for offset := 1; offset < l.len; offset += 4 {
			c := l[offset]

			match c {
				`A`...`Z` {
					stacks[int(offset / 4)] << c
					stacks2[int(offset / 4)] << c
				}
				`0`...`9` {
					break
				}
				else {}
			}
		}
	}
}

mut tops := ''

mut keys := stacks.keys()
keys.sort()

for i in keys {
	tops += stacks[i][0].ascii_str()
}

println(tops)

tops = ''

keys = stacks2.keys()
keys.sort()

for i in keys {
	tops += stacks2[i][0].ascii_str()
}

println(tops)
