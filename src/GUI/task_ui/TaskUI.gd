extends Control

onready var tab_list = $"MarginContainer/TextureRect/MarginContainer/HBoxContainer/VBoxContainer2/ScrollContainer/VBoxContainer3"
onready var task_bar_progression = $"MarginContainer/TextureRect/MarginContainer/HBoxContainer/VBoxContainer/MarginContainer2"

func back():
	hide()
	get_tree().call_group_flags(2, "update_data", "update_data")

func _ready():
	initialize()
	
func initialize():
	tab_list.initialize(task_bar_progression)

func load_task():
	tab_list.load_task()
