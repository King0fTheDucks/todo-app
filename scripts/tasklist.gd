extends Control

var day: int
var month: int
var year: int
var tasks: Array[Array] = []

var all: VBoxContainer
var today: VBoxContainer
var monthly: VBoxContainer
var yearly: VBoxContainer

var main: Node

func _ready() -> void:
	main = MainController.get_mainframe(self)
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
		else:
			var date_split := []
			date_split = tasks[i][1].split("/")
			if int(date_split[2]) == year:
				add_task_to_tab(yearly, i)
				if int(date_split[0]) == month:
					add_task_to_tab(monthly, i)
					if int(date_split[1]) == day:
						add_task_to_tab(today, i)

func _process(_delta: float) -> void:
	pass

func add_task_to_tab(tab: VBoxContainer, iteration: int) -> void:
	var task_instance := load("res://scenes/task.tscn")
	var task = task_instance.instantiate()
	task.set("todo_date", tasks[iteration][1])
	task.call("set_task_name", tasks[iteration][0])
	tab.add_child(task)
