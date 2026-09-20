extends Control

@export var id: int = 0
@export var taskname: String = ""
@export var todo_date: String = ""
@export var completed: bool = false

var icon: TextureButton
var trash: TextureButton
var task_label: Label
var main: Node

func _ready() -> void:
	main = MainController.get_mainframe(self)
	icon = get_node("HBoxContainer/Icon")
	task_label = get_node("HBoxContainer/TaskName")
	trash = get_node("HBoxContainer/Trash")
	set_task_label(taskname, todo_date)
	icon.pressed.connect(_on_icon_pressed)
	trash.pressed.connect(_on_trash_pressed)

func _process(_delta: float) -> void:
	if completed == true:
		if icon.texture_normal == main.call("get_unchecked_ico"):
			set_icon(main.call("get_checked_ico"))
	else:
		if icon.texture_normal == main.call("get_checked_ico"):
			set_icon(main.call("get_unchecked_ico"))

func set_task_label(msg: String, date: String) -> void:
	task_label.text = msg + "\nComplete by: " + date

func set_task_name(msg: String) -> void:
	taskname = msg

func set_icon(ico: Texture2D) -> void:
	icon.texture_normal = ico
	icon.texture_pressed = ico
	icon.texture_hover = ico
	icon.texture_disabled = ico
	icon.texture_focused = ico

func _on_icon_pressed() -> void:
	completed = !completed
	main.call("set_task_complete", id, completed)
	main.call("next_scene", "res://scenes/tasklist.tscn")

func _on_trash_pressed() -> void:
	get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().call("confirm_deletion", id, taskname)
