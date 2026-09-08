class_name MainController
extends Node

static func get_mainframe(node: Node) -> Node:
	var scene_root: Node = node.get_tree().current_scene
	while node.get_parent() != null and node != scene_root:
		node = node.get_parent()
	return node
