extends Control

var day: int
var month: int
var year: int
var tasks: Array[Array] = []

var add_task: Button
var tab_container: TabContainer
var all: VBoxContainer
var today: VBoxContainer
var monthly: VBoxContainer
var yearly: VBoxContainer

var main: Node

func _ready() -> void:
	main = MainController.get_mainframe(self)
	add_task = get_node("Title/HBoxContainer/AddTask")
	tab_container = get_node("Tasks/TabContainer")
	all = get_node("Tasks/TabContainer/All/ScrollContainer/VBoxContainer")
	today = get_node("Tasks/TabContainer/Today/ScrollContainer/VBoxContainer")
	monthly = get_node("Tasks/TabContainer/Monthly/ScrollContainer/VBoxContainer")
	yearly = get_node("Tasks/TabContainer/Yearly/ScrollContainer/VBoxContainer")
	tasks = main.call("get_tasks")
	var date_dict: Dictionary = Time.get_date_dict_from_system()
	day = date_dict.get("day", 0)
	month = date_dict.get("month", 0)
	year = date_dict.get("year", 0)
	for i in range(len(tasks)):
		add_task_to_tab(all, i)
		if tasks[i][1] == "DAILY":
			add_task_to_tab(today, i)
			add_task_to_tab(monthly, i)
			add_task_to_tab(yearly, i)
		else:
			var date_split := []
			date_split = tasks[i][1].split("/")
			if int(date_split[2]) == year:
				add_task_to_tab(yearly, i)
				if int(date_split[0]) == month:
					add_task_to_tab(monthly, i)
					if int(date_split[1]) == day:
						add_task_to_tab(today, i)
	tab_container.current_tab = main.get("last_tab")
	tab_container.tab_changed.connect(_on_tab_changed)
	add_task.pressed.connect(_on_add_task_pressed)

func add_task_to_tab(tab: VBoxContainer, iteration: int) -> void:
	var task_instance: PackedScene = load("res://scenes/task.tscn")
	var task: Control = task_instance.instantiate()
	task.set("id", iteration)
	task.set("completed", tasks[iteration][2])
	task.set("todo_date", tasks[iteration][1])
	task.call("set_task_name", tasks[iteration][0])
	tab.add_child(task)

func confirm_deletion(id: int, taskname: String) -> void:
	var delete_prompt_instance: PackedScene = load("res://scenes/delete_prompt.tscn")
	var delete_prompt: Control = delete_prompt_instance.instantiate()
	delete_prompt.set("id", id)
	delete_prompt.set("taskname", taskname)
	add_child(delete_prompt)

func _on_tab_changed(tab: int) -> void:
	main.set("last_tab", tab)

func _on_add_task_pressed() -> void:
	main.call("next_scene", "res://scenes/add_task.tscn")
