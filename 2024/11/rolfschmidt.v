import arrays
import os

fn halve_string(s string) []i64 {
    half_len := s.len / 2
    return [s[..half_len].i64(), s[half_len..].i64()]
}

fn run(rounds i64) i64 {
    mut check := map[i64]i64{}

    for num in os.read_file('stones.input')!.split(' ') {
        check[num.i64()] = 1
    }

    for _ in 0 .. rounds {
        mut cloned := map[i64]i64{}
        for key, value in check {
            cloned[key] = value
        }

        for num, count in cloned {
            new_values := if num == 0 {
                [i64(1)]
            } else if num.str().len % 2 == 0 {
                halve_string(num.str())
            } else {
                [num * i64(2024)]
            }

            check[num] -= count
            for new_value in new_values {
                if new_value !in check {
                    check[new_value] = 0
                }
                check[new_value] += count
            }
        }
    }

    return arrays.sum(check.values()) or { 0 }
}

fn main() {
    println(run(25)) 
    println(run(75))
}