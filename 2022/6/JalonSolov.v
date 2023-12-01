import os

const start_of_packet_marker = 4
const start_of_message_marker = 14

fn find_marker(stream []u8, marker_len int) !int {
	mut dup := false

	for offset in 0 .. stream.len - marker_len {
		dup = false

		for o1 in offset .. offset + marker_len {
			for o2 in o1 + 1 .. offset + marker_len {
				if stream[o1] == stream[o2] {
					dup = true
					break
				}
			}

			if dup {
				break
			}
		}

		if !dup {
			return offset + marker_len
		}
	}

	return error('no marker found')
}

stream := os.read_file('datastream.input')!.bytes()

println('Start of packet: ${find_marker(stream, start_of_packet_marker)!}')
println('Start of message: ${find_marker(stream, start_of_message_marker)!}')
