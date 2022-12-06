# adventofcode

A repository for solutions to [Advent of Code](https://adventofcode.com/about) puzzles,
written in the [V](https://vlang.io/) language.

Initial layout:

A directory for the year, with subdirs for each day.

Inside each day subdir, example input file for that day, and individual solutions named
by the GitHub ID of the person who supplied it followed by `.v` to identify it as a V
language file.

If you have a solution that is more complex than a single `.v` file, make a subdir with
your GitHub ID under the appropriate year/day subdir, and place all files there.

Note: when you add .input files, please turn off the auto trimming
functionality of your editor/IDE. Some solutions require the .input
files to have the exact same format that AoC uses, and trimming end
lines may break them.

Note 2: there is a small script that can be used to verify that all
solutions continue to work with latest V versions. You can use it by
running `v run verify.v` in the top folder of this repository.
It will produce the necessary .out files for new solutions, and you
can just commit them, so that the CI will check that there are no
regressions.
