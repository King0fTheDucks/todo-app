extends Control

var day: int
var month: int
var year: int
var tasks: Array[Array] = []

var add_task: Button
var tab_container: TabContainer
var scrollcontainer_all: ScrollContainer
var scrollcontainer_today: ScrollContainer
var scrollcontainer_monthly: ScrollContainer
var scrollcontainer_yearly: ScrollContainer
var all: VBoxContainer
var today: VBoxContainer
var monthly: VBoxContainer
var yearly: VBoxContainer

var main: Node

func _ready() -> void:
	main = MainController.get_mainframe(self)
	add_task = get_node("Title/HBoxContainer/AddTask")
	tab_container = get_node("Tasks/TabContainer")
	scrollcontainer_all = get_node("Tasks/TabContainer/All/ScrollContainer")
	scrollcontainer_today = get_node("Tasks/TabContainer/Today/ScrollContainer")
	scrollcontainer_monthly = get_node("Tasks/TabContainer/Monthly/ScrollContainer")
	scrollcontainer_yearly = get_node("Tasks/TabContainer/Yearly/ScrollContainer")
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
	scrollcontainer_all.set_deferred("scroll_vertical", main.get("last_scroll_all"))
	scrollcontainer_today.set_deferred("scroll_vertical", main.get("last_scroll_today"))
	scrollcontainer_monthly.set_deferred("scroll_vertical", main.get("last_scroll_monthly"))
	scrollcontainer_yearly.set_deferred("scroll_vertical", main.get("last_scroll_yearly"))
	tab_container.current_tab = main.get("last_tab")
	tab_container.tab_changed.connect(_on_tab_changed)
	add_task.pressed.connect(_on_add_task_pressed)

func _process(_delta: float) -> void:
	if scrollcontainer_all.scroll_vertical != main.get("last_scroll_all"):
		main.set("last_scroll_all", scrollcontainer_all.scroll_vertical)
	if scrollcontainer_today.scroll_vertical != main.get("last_scroll_today"):
		main.set("last_scroll_today", scrollcontainer_today.scroll_vertical)
	if scrollcontainer_monthly.scroll_vertical != main.get("last_scroll_monthly"):
		main.set("last_scroll_monthly", scrollcontainer_monthly.scroll_vertical)
	if scrollcontainer_yearly.scroll_vertical != main.get("last_scroll_yearly"):
		main.set("last_scroll_yearly", scrollcontainer_yearly.scroll_vertical)

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
