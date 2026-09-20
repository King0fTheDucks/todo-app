class_name Main
extends Node

@export var default_scene_path: String = "res://"
const TASKLIST: String = "user://tasklist.txt"
var tasks: Array[Array] = []
var last_tab: int = 0
var unchecked_ico: Texture2D
var checked_ico: Texture2D

func _ready() -> void:
	tasks = load_list()
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

func save_list() -> void:
	var text: String = ""
	for i in range(len(tasks)):
		for x in range(len(tasks[i])):
			if typeof(tasks[i][x]) == TYPE_STRING:
				text += tasks[i][x]
			else:
				text += str(tasks[i][x])
			text += ", "
		text = text.left(text.length() - 2)
		text += '\\'
	text = text.left(text.length() - 1)
	var file: FileAccess = FileAccess.open(TASKLIST, FileAccess.WRITE)
	file.store_string(text)
	file.close()

func load_list() -> Array[Array]:
	if FileAccess.file_exists(TASKLIST) == false:
		return []
	var file: FileAccess = FileAccess.open(TASKLIST, FileAccess.READ)
	var text: String = file.get_as_text()
	file.close()
	var basic_array: Array = text.split('\\')
	var completed_array: Array[Array] = []
	for i in range(len(basic_array)):
		var task: Array = basic_array[i].split(', ')
		if task[2].to_lower() == "true":
			task[2] = true
		else:
			task[2] = false
		completed_array.append(task)
	return completed_array

func set_task_complete(id: int, complete: bool) -> void:
	tasks[id][2] = complete
	save_list()

func set_tasks(new: Array[Array]) -> void:
	tasks = new
	save_list()

func add_task(new: Array) -> void:
	tasks.append(new)
	save_list()

func get_tasks() -> Array:
	return tasks

func get_unchecked_ico() -> Texture2D:
	return unchecked_ico

func get_checked_ico() -> Texture2D:
	return checked_ico
