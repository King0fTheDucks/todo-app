extends Control

var name_valid: bool = false
var date_valid: bool = false

var name_text: TextEdit
var date_text: TextEdit
var name_err: Label
var date_err: Label
var add: Button
var cancel: Button
var main: Node

func _ready() -> void:
	main = MainController.get_mainframe(self)
	name_text = get_node("TaskArgs/PanelContainer/MarginContainer/ScrollContainer/VBoxContainer/NameText")
	date_text = get_node("TaskArgs/PanelContainer/MarginContainer/ScrollContainer/VBoxContainer/DateText")
	name_err = get_node("TaskArgs/PanelContainer/MarginContainer/ScrollContainer/VBoxContainer/NameErr")
	date_err = get_node("TaskArgs/PanelContainer/MarginContainer/ScrollContainer/VBoxContainer/DateErr")
	add = get_node("TaskArgs/PanelContainer/MarginContainer/HBoxContainer/Add")
	cancel = get_node("TaskArgs/PanelContainer/MarginContainer/HBoxContainer/Cancel")
	add.pressed.connect(_on_add_pressed)
	cancel.pressed.connect(_on_cancel_pressed)

func _process(_delta: float) -> void:
	check_validity()
	lookup_validity()

func check_validity() -> void:
	if name_text.text.length() == 0 || name_text.text.length() >= 25:
		name_valid = false
	else:
		name_valid = true
	if date_text.text.length() == 10:
		for i in range(len(date_text.text)):
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
		if date_text.text.to_upper() == "DAILY":
			date_valid = true
		else:
			date_valid = false

func lookup_validity() -> void:
	if name_valid == false:
		name_err.show()
	else:
		name_err.hide()
	if date_valid == false:
		date_err.show()
	else:
		date_err.hide()
	if name_valid == true && date_valid == true:
		add.show()
	else:
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
	var new_task: Array = [name_text.text, date_text.text, false]
	main.call("add_task", new_task)
	main.call("next_scene", "res://scenes/tasklist.tscn")

func _on_cancel_pressed() -> void:
	main.call("next_scene", "res://scenes/tasklist.tscn")
