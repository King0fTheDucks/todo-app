extends Control

@export var edit_mode: bool = false
@export var edit_id: int = false
@export var edit_name: String = ""
@export var edit_todo_date: String = ""

var name_valid: bool = false
var date_valid: bool = false

var name_text: TextEdit
var date_text: TextEdit
var title_label: Label
var name_err: Label
var date_err: Label
var add: Button
var cancel: Button
var main: Node

func _ready() -> void:
	main = MainController.get_mainframe(self)
	title_label = get_node("Title/Label")
	name_text = get_node("TaskArgs/PanelContainer/MarginContainer/ScrollContainer/VBoxContainer/NameText")
	date_text = get_node("TaskArgs/PanelContainer/MarginContainer/ScrollContainer/VBoxContainer/DateText")
	name_err = get_node("TaskArgs/PanelContainer/MarginContainer/ScrollContainer/VBoxContainer/NameErr")
	date_err = get_node("TaskArgs/PanelContainer/MarginContainer/ScrollContainer/VBoxContainer/DateErr")
	add = get_node("TaskArgs/PanelContainer/MarginContainer/HBoxContainer/Add")
	cancel = get_node("TaskArgs/PanelContainer/MarginContainer/HBoxContainer/Cancel")
	if edit_mode:
		title_label.text = "EDIT TASK"
		name_text.text = edit_name
		date_text.text = edit_todo_date
		add.text = "Confirm"
	add.pressed.connect(_on_add_pressed)
	cancel.pressed.connect(_on_cancel_pressed)

func _process(_delta: float) -> void:
	if name_text.text.contains("\n") || date_text.text.contains("\n"):
		name_text.text = name_text.text.replace("\n", "")
		date_text.text = date_text.text.replace("\n", "")
		if name_valid && date_valid:
			_on_add_pressed()
	check_validity()
	lookup_validity()

func check_validity() -> void:
	if name_text.text.length() == 0 || name_text.text.strip_edges().length() >= 25:
		name_valid = false
	else:
		name_valid = true
	if date_text.text.strip_edges().length() == 10:
		for i in range(len(date_text.text.strip_edges())):
			if i != 2 && i != 5:
				if date_text.text[i].is_valid_int() == false:
					date_valid = false
					break
				else:
					date_valid = is_date_valid(date_text.text)
					continue
			else:
				if date_text.text[i] == '/':
					date_valid = is_date_valid(date_text.text)
					continue
				else:
					date_valid = false
					break
	else:
		if date_text.text.strip_edges().to_upper() == "DAILY":
			date_valid = true
		else:
			date_valid = false

func lookup_validity() -> void:
	if !name_valid:
		name_err.show()
	else:
		name_err.hide()
	if !date_valid:
		date_err.show()
	else:
		date_err.hide()
	if name_valid && date_valid:
		add.show()
	else:
		if !add.hidden:
			add.hide()

func is_date_valid(date: String) -> bool:
	var mdy: PackedStringArray = date.split('/')
	var days: int = 0
	if int(mdy[0]) < 1 || int(mdy[0]) > 12:
		return false
	match int(mdy[0]):
		1:
			days = 31
		2:
			days = 29
		3:
			days = 31
		4:
			days = 30
		5:
			days = 31
		6:
			days = 30
		7:
			days = 31
		8:
			days = 31
		9:
			days = 30
		10:
			days = 31
		11:
			days = 30
		12:
			days = 31
		_:
			printerr("ERROR: Invalid month number.")
			days = 30
	if int(mdy[1]) < 1 || int(mdy[1]) > days:
		return false
	if int(mdy[2]) < 1000:
		return false
	return true

func _on_add_pressed() -> void:
	var new_task: Array = [name_text.text, date_text.text.to_upper(), false]
	if edit_mode:
		main.call("edit_task", edit_id, new_task)
	else:
		main.call("add_task", new_task)
	main.call("next_scene", "res://scenes/tasklist.tscn")

func _on_cancel_pressed() -> void:
	main.call("next_scene", "res://scenes/tasklist.tscn")
