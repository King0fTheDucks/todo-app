class_name Main
extends Node

@export var default_scene_path: String = "res://"
const TASKLIST: String = "user://tasklist.txt"
const LAST_DATE: String = "user://last_date.date"
var tasks: Array[Array] = [] # Formatted as: ["TASKNAME", "MM/DD/YYYY", true/false]
var last_tab: int = 0
var last_scroll_all: int = 0
var last_scroll_today: int = 0
var last_scroll_weekly: int = 0
var last_scroll_monthly: int = 0
var last_scroll_yearly: int = 0
var last_scroll_past_due: int = 0
var dark_mode: bool = false
var classic_checks: bool = false
var unchecked_ico: Texture2D
var checked_ico: Texture2D
var classic_checked_ico: Texture2D

func _ready() -> void:
	tasks = load_list()
	sort_tasks()
	unchecked_ico = preload("res://assets/unchecked.png")
	checked_ico = preload("res://assets/checked.png")
	classic_checked_ico = preload("res://assets/old/checked_new.png")
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
	if file.get_length() == 0:
		return []
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

func save_date(m: int, d: int, y: int) -> void:
	var file: FileAccess = FileAccess.open(LAST_DATE, FileAccess.WRITE)
	file.store_string(str(m) + "/" + str(d) + "/" + str(y))
	file.close()

func load_date() -> Array[int]:
	if !FileAccess.file_exists(TASKLIST):
		return [1, 1, 2000]
	var file: FileAccess = FileAccess.open(LAST_DATE, FileAccess.READ)
	if file.get_length() == 0:
		printerr("ERROR: File length of \'" + LAST_DATE + "\' is zero.")
		return [1, 1, 2000]
	var text: String = file.get_as_text()
	file.close()
	var string_array: PackedStringArray = text.split("/")
	var final_array: Array[int] = [int(string_array[0]), int(string_array[1]), int(string_array[2])]
	return final_array

func check_date(m: int, d: int, y: int) -> void:
	if load_date() != [m, d, y]:
		for i in len(tasks):
			if tasks[i][1] == "DAILY":
				tasks[i][2] = false
	save_list()
	save_date(m, d, y)

func goto_edit_scene(id: int, taskname: String, todo_date: String, n: String = "Scene0"):
	remove_scene(n)
	var scn_instance = load("res://scenes/add_task.tscn")
	var scn = scn_instance.instantiate()
	scn.name = n
	scn.edit_mode = true
	scn.edit_id = id
	scn.edit_name = taskname
	scn.edit_todo_date = todo_date
	add_child(scn)

func set_task_complete(id: int, complete: bool) -> void:
	tasks[id][2] = complete
	save_list()

func set_tasks(new: Array[Array]) -> void:
	tasks = new
	sort_tasks()
	save_list()

func add_task(new: Array) -> void:
	tasks.append(new)
	sort_tasks()
	save_list()

func edit_task(id: int, new: Array) -> void:
	tasks[id] = new
	sort_tasks()
	save_list()

func sort_tasks() -> void:
	tasks.sort_custom(func(a: Array, b: Array) -> bool:
		var date_a: String = str(a[1])
		var date_b: String = str(b[1])
		
		if date_a == "DAILY" and date_b != "DAILY":
			return true
		if date_b == "DAILY" and date_a != "DAILY":
			return false
		
		if date_a == "DAILY" and date_b == "DAILY":
			return str(a[0]).to_lower() < str(b[0]).to_lower()
		
		var parts_a: PackedStringArray = date_a.split("/")
		var parts_b: PackedStringArray = date_b.split("/")
		
		var timestamp_a: int = int(Time.get_unix_time_from_datetime_dict({
			"year": int(parts_a[2]),
			"month": int(parts_a[0]),
			"day": int(parts_a[1]),
			"hour": 0,
			"minute": 0,
			"second": 0
		}))
		
		var timestamp_b: int = int(Time.get_unix_time_from_datetime_dict({
			"year": int(parts_b[2]),
			"month": int(parts_b[0]),
			"day": int(parts_b[1]),
			"hour": 0,
			"minute": 0,
			"second": 0
		}))
	
		if timestamp_a != timestamp_b:
			return timestamp_a < timestamp_b
		
		return str(a[0]).to_lower() < str(b[0]).to_lower()
	)

func get_tasks() -> Array:
	return tasks

func get_unchecked_ico() -> Texture2D:
	return unchecked_ico

func get_checked_ico() -> Texture2D:
	if classic_checks:
		return classic_checked_ico
	return checked_ico
