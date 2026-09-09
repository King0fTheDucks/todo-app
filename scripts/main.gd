class_name Main
extends Node

@export var default_scene_path: String = "res://"
var tasks: Array[Array] = [["Do the flop", "10/22/2026"], ["Take out the trash", "09/21/2026"], ["Take the dog for a walk", "DAILY"], ["Next year task", "02/22/2027"]]
var unchecked_ico: Texture2D
var checked_ico: Texture2D

func _ready() -> void:
	unchecked_ico = preload("res://assets/unchecked.png")
	checked_ico = preload("res://assets/checked.png")
	add_scene(default_scene_path)

func add_scene(pth: String, n: String = "Scene0"):
	var scn_instance = load(pth)
	var scn = scn_instance.instantiate()
	scn.name = n
	add_child(scn)

func remove_scene(n: String = "Scene0"):
	if get_node_or_null(n) != null:
		remove_child(get_node(n))
	else:
		printerr("ERROR: Could not remove child " + n + ". Node did not exist.")

func next_scene(pth: String, n: String = "Scene0"):
	remove_scene(n)
	var scn_instance = load(pth)
	var scn = scn_instance.instantiate()
	scn.name = n
	add_child(scn)

func _process(_delta: float) -> void:
	pass

func get_tasks() -> Array:
	return tasks

func get_unchecked_ico() -> Texture2D:
	return unchecked_ico

func get_checked_ico() -> Texture2D:
	return checked_ico
