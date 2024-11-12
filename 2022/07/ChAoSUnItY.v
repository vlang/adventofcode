import os { read_file }
import arrays { sum }

struct FileSystem {
mut:
	current_node usize
	nodes        []Node
}

fn new_fs() FileSystem {
	return FileSystem{
		current_node: 0
		nodes:        [DirNode{
			name:   '/'
			parent: none
		}]
	}
}

fn (mut fs FileSystem) cd(directory string) {
	fs.current_node = match directory {
		'/' {
			0
		}
		'..' {
			node := fs.nodes[fs.current_node]

			match node {
				DirNode {
					node.parent or { 0 }
				}
				else {
					panic('unreachable')
				}
			}
		}
		else {
			node := fs.nodes[fs.current_node]

			match node {
				DirNode {
					mut found_node := usize(0)

					for child in node.children {
						child_node := fs.nodes[child]

						if child_node is DirNode && child_node.name == directory {
							found_node = child
							break
						}
					}

					found_node
				}
				else {
					panic('unreachable')
				}
			}
		}
	}
}

fn (mut fs FileSystem) update_parent_dir_size(size u32, parent usize) {
	mut parent_node := fs.nodes[parent]

	match mut parent_node {
		DirNode {
			parent_node.size += size

			if grand_parent := parent_node.parent {
				fs.update_parent_dir_size(size, grand_parent)
			}
		}
		else {}
	}
}

fn (mut fs FileSystem) add_file(name string, size u32) {
	fs.add_node(FileNode{ name: name, size: size })
	fs.update_parent_dir_size(size, fs.current_node)
}

fn (mut fs FileSystem) add_dir(name string) {
	fs.add_node(DirNode{ name: name, parent: fs.current_node })
}

fn (mut fs FileSystem) add_node(node Node) {
	index := fs.nodes.len
	fs.nodes << node
	mut current_node := fs.nodes[fs.current_node]
	match mut current_node {
		DirNode {
			current_node.children << usize(index)
		}
		else {}
	}
}

fn (fs &FileSystem) dirs() []DirNode {
	mut dir_nodes := []DirNode{}

	for node in fs.nodes {
		if node is DirNode {
			dir_nodes << node
		}
	}

	return dir_nodes
}

fn (fs &FileSystem) size() u32 {
	return fs.nodes[0].NodeBase.size
}

type Node = DirNode | FileNode

struct NodeBase {
	name string
mut:
	size u32
}

struct FileNode {
	NodeBase
}

struct DirNode {
	NodeBase
	parent ?usize
mut:
	children []usize = []
}

fn main() {
	data := read_file('filesystem.input')!
	fs := process_data(data)

	println(part1(&fs)!)
	println(part2(&fs)!)
}

fn part1(fs &FileSystem) !u32 {
	return sum(fs.dirs().map(it.size).filter(it < 100_000))!
}

fn part2(fs &FileSystem) !u32 {
	mut dir_sizes := fs.dirs().map(it.size)

	dir_sizes.sort()

	for size in dir_sizes {
		if size >= (30_000_000 - (70_000_000 - fs.size())) {
			return size
		}
	}

	return 0
}

fn process_data(data string) FileSystem {
	mut fs := new_fs()

	for executions in data.replace('\r\n', '\n').split('$').filter(it.len != 0).map(it.split('\n')) {
		command := executions[0]

		match command[1..3] {
			'cd' {
				fs.cd(command[4..])
			}
			'ls' {
				for children in executions#[1..-1] {
					children_segment := children.split(' ')
					attribute := children_segment[0]
					name := children_segment[1]

					if attribute.starts_with('dir') {
						fs.add_dir(name)
					} else {
						fs.add_file(name, attribute.u32())
					}
				}
			}
			else {
				panic('unreachable')
			}
		}
	}

	return fs
}
