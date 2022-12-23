// $origin: https://github.com/rolfschmidt/advent-of-code

module main

import os

struct D4Passport {
mut:
	byr int
	iyr int
	eyr int
	hgt string
	hcl string
	ecl string
	pid string
	cid int
}

fn (p D4Passport) byr_valid() bool {
	return p.byr >= 1920 && p.byr <= 2002
}

fn (p D4Passport) iyr_valid() bool {
	return p.iyr >= 2010 && p.iyr <= 2020
}

fn (p D4Passport) eyr_valid() bool {
	return p.eyr >= 2020 && p.eyr <= 2030
}

fn (p D4Passport) hgt_valid() bool {
	if p.hgt.len < 3 {
		return false
	}
	typ := p.hgt[p.hgt.len - 2..]
	if ['cm', 'in'].index(typ) == -1 {
		return false
	}
	value := p.hgt.int()
	if typ == 'cm' && value >= 150 && value <= 193 {
		return true
	}
	if typ == 'in' && value >= 59 && value <= 76 {
		return true
	}
	return false
}

fn (p D4Passport) hcl_valid() bool {
	if p.hcl[0] != `#` || p.hcl.len != 7 {
		return false
	}
	for i := 1; i < p.hcl.len; i++ {
		if (p.hcl[i] < `a` || p.hcl[i] > `f`) && (p.hcl[i] < `0` || p.hcl[i] > `9`) {
			return false
		}
	}
	return true
}

fn (p D4Passport) ecl_valid() bool {
	return ['amb', 'blu', 'brn', 'gry', 'grn', 'hzl', 'oth'].index(p.ecl) != -1
}

fn (p D4Passport) pid_valid() bool {
	return p.pid.len == 9 && p.pid.bytes().filter(it.is_digit()).len == 9
}

fn (p D4Passport) valid() bool {
	return p.byr > 0 &&
		p.iyr > 0 && p.eyr > 0 && p.hgt.len > 0 && p.hcl.len > 0 && p.ecl.len > 0 && p.pid.len > 0
}

fn (p D4Passport) valid_deep() bool {
	return p.valid() && p.byr_valid() && p.iyr_valid() && p.eyr_valid() && p.hgt_valid() && p.hcl_valid() &&
		p.ecl_valid() && p.pid_valid()
}

fn d4_parse_passport(passports_data string) []D4Passport {
	mut result := []D4Passport{}
	for block in passports_data.split('\n\n') {
		mut passport := D4Passport{}
		for variable in block.replace('\n', ' ').split(' ') {
			var_split := variable.split(':')
			if var_split[0] == 'byr' {
				passport.byr = var_split[1].int()
			} else if var_split[0] == 'iyr' {
				passport.iyr = var_split[1].int()
			} else if var_split[0] == 'eyr' {
				passport.eyr = var_split[1].int()
			} else if var_split[0] == 'hgt' {
				passport.hgt = var_split[1]
			} else if var_split[0] == 'hcl' {
				passport.hcl = var_split[1]
			} else if var_split[0] == 'ecl' {
				passport.ecl = var_split[1]
			} else if var_split[0] == 'pid' {
				passport.pid = var_split[1]
			} else if var_split[0] == 'cid' {
				passport.cid = var_split[1].int()
			} else {
				panic('no type')
			}
		}
		result << passport
	}
	return result
}

fn day04a() int {
	passports_data := read_day_string('4.input')
	mut passports := d4_parse_passport(passports_data)
	return passports.filter(it.valid()).len
}

fn day04b() int {
	passports_data := read_day_string('4.input')
	mut passports := d4_parse_passport(passports_data)
	return passports.filter(it.valid_deep()).len
}

fn main() {
	println(day04a())
	println(day04b())
}

fn read_day_string(path string) string {
	mut data := os.read_file(path) or { panic(err) }
	return data.trim(' \n\t\v\f\r')
}
