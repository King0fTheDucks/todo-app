extends Control

var dark_mode_setting: bool = false
var classic_checks_setting: bool = false
var bg: ColorRect
var dark_mode_button: TextureButton
var classic_checks_button: TextureButton
var save_button: Button
var cancel_button: Button
var main: Node

func _ready() -> void:
	main = MainController.get_mainframe(self)
	bg = get_node("BG")
	dark_mode_button = get_node("Options/PanelContainer/MarginContainer/ScrollContainer/VBoxContainer/DarkMode/Button")
	classic_checks_button = get_node("Options/PanelContainer/MarginContainer/ScrollContainer/VBoxContainer/ClassicChecks/Button")
	save_button = get_node("Options/PanelContainer/MarginContainer/HBoxContainer/Save")
	cancel_button = get_node("Options/PanelContainer/MarginContainer/HBoxContainer/Cancel")
	if main.get("dark_mode"):
		bg.color = Color(0, 0, 0)
	else:
		bg.color = Color(255, 255, 255)
	dark_mode_setting = main.get("dark_mode")
	classic_checks_setting = main.get("classic_checks")
	dark_mode_button.pressed.connect(_on_dark_mode_button_pressed)
	classic_checks_button.pressed.connect(_on_classic_checks_button_pressed)
	save_button.pressed.connect(_on_save_pressed)
	cancel_button.pressed.connect(_on_cancel_pressed)

func _process(_delta: float) -> void:
	if dark_mode_setting:
		dark_mode_button.texture_normal = load("res://assets/setting_on.png")
		dark_mode_button.texture_pressed = load("res://assets/setting_on.png")
		dark_mode_button.texture_hover = load("res://assets/setting_on.png")
		dark_mode_button.texture_disabled = load("res://assets/setting_on.png")
		dark_mode_button.texture_focused = load("res://assets/setting_on.png")
	else:
		dark_mode_button.texture_normal = load("res://assets/setting_off.png")
		dark_mode_button.texture_pressed = load("res://assets/setting_off.png")
		dark_mode_button.texture_hover = load("res://assets/setting_off.png")
		dark_mode_button.texture_disabled = load("res://assets/setting_off.png")
		dark_mode_button.texture_focused = load("res://assets/setting_off.png")
	
	if classic_checks_setting:
		classic_checks_button.texture_normal = load("res://assets/setting_on.png")
		classic_checks_button.texture_pressed = load("res://assets/setting_on.png")
		classic_checks_button.texture_hover = load("res://assets/setting_on.png")
		classic_checks_button.texture_disabled = load("res://assets/setting_on.png")
		classic_checks_button.texture_focused = load("res://assets/setting_on.png")
	else:
		classic_checks_button.texture_normal = load("res://assets/setting_off.png")
		classic_checks_button.texture_pressed = load("res://assets/setting_off.png")
		classic_checks_button.texture_hover = load("res://assets/setting_off.png")
		classic_checks_button.texture_disabled = load("res://assets/setting_off.png")
		classic_checks_button.texture_focused = load("res://assets/setting_off.png")

func _on_dark_mode_button_pressed() -> void:
	dark_mode_setting = !dark_mode_setting

func _on_classic_checks_button_pressed() -> void:
	classic_checks_setting = !classic_checks_setting

func _on_save_pressed() -> void:
	main.set("dark_mode", dark_mode_setting)
	main.set("classic_checks", classic_checks_setting)
	main.call("save_settings")
	main.call("next_scene", "res://scenes/tasklist.tscn")

func _on_cancel_pressed() -> void:
	main.call("next_scene", "res://scenes/tasklist.tscn")
