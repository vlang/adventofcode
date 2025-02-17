import os
import log
import time

log.use_stdout()
unbuffer_stdout()
year := os.args[1] or { '${time.now().year}' }.int()
log.info('> creating folder structure for year: ${year} ...')
for d in 1 .. 25 + 1 {
	dfolder := './${year:04}/${d:02}'
	log.info('creating ${dfolder} ...')
	os.mkdir_all(dfolder)!
	os.write_file(os.join_path(dfolder, '.gitkeep'), '')!
}
log.info('done')
