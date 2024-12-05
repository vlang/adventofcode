# adventofcode

A repository for V language solutions to [Advent of Code](https://adventofcode.com/about) puzzles.

Initial layout:

A directory for the year, with subdirs for each day.

Inside each day subdir, example input file for that day, and individual solutions named
by the GitHub ID of the person who supplied it followed by `.v` to identify it as a V
language file.

If you have a solution that is more complex than a single `.v` file, make a subdir with
your GitHub ID under the appropriate year/day subdir, and place all files there.

## Input file format

1. Input file should end with file extension `.input`
2. Input file should be directly copied/pasted from AoC's example input with the following
standard:
    - No whitespace trimming (see Note 1 below)
    - No additional empty line
    - No personal-specific input allowed in example input file
3. If there are multiple example inputs for different parts in a day, suffix each
input file with `-partX` where X is part number, then follow other criteria
4. Input file's name should relate to the corresponding AoC problem, for example: AoC 2022
Day 7 relates to unix system's file system cmd operations, therefore, you should
name it `filesystem.input` or `cmd.input`

Note 1: when you add `.input` files, please turn off the auto trimming
functionality of your editor/IDE. Some solutions require the `.input`
files to have the exact same format that AoC uses, and trimming end
lines may break them.

Note 2: there is a small script that can be used to verify that all
solutions continue to work with latest V versions. You can use it by
running `v run verify.v` in the top folder of this repository.
It will produce the necessary `.out` files for new solutions, and you
can commit them so that the CI will check that there are no
regressions.

## Naming convention for solutions that are split in 2 .v files for each part.

The `verify.v` script, supports passing the input files as stdin to your programs.

1. If you name your solution with a suffix part1.v, then it will get the
input file, that ends with part1.input in its stdin.
2. If you name your solution with a suffix part2.v, then it will get the
input file, that ends with part2.input in its stdin.
3. In any other case, or if a matching input file is not found, you will
get the first .input file in your stdin, no matter how it was named.

Note: you can use `lines := os.get_raw_lines()` to read the input from stdin.

# Leaderboard

Feel free to join the vlang leaderboard: `1303110-4f92d16a`.
