import os

mut total_calories := []int{}
mut calories := 0

lines := os.read_lines('calories.input')!

for l in lines {
        if l == '' {
                total_calories << calories
                calories = 0
                continue
        }

        calories += l.int()
}

if calories > 0 {
        total_calories << calories
}

total_calories.sort(b < a)

println('Max single calories: ${total_calories[0]}.\nTop 3 combined: ${total_calories[0] + total_calories[1] + total_calories[2]}.')
