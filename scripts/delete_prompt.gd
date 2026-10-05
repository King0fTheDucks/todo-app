extends Control

@export var id: int = 0
@export var taskname: String = ""
var title_label: Label
var yes: Button
var no: Button

func _ready() -> void:
	title_label = get_node("MarginContainer/PanelContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/Label")
	yes = get_node("MarginContainer/PanelContainer/MarginContainer/PanelContainer/MarginContainer/Confirmation/Yes")
	no = get_node("MarginContainer/PanelContainer/MarginContainer/PanelContainer/MarginContainer/Confirmation/No")
	title_label.text = "Delete task entry \"" + taskname + "\"?\n\n\n"
	yes.pressed.connect(_on_yes_pressed)
	no.pressed.connect(_on_no_pressed)

func _on_yes_pressed() -> void:
	var main: Node = MainController.get_mainframe(self)
	var tasks: Array[Array] = main.call("get_tasks")
	tasks.remove_at(id)
	main.call("set_tasks", tasks)
	main.call("next_scene", "res://scenes/tasklist.tscn")

func _on_no_pressed() -> void:
	queue_free()
