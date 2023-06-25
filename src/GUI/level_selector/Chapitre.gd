extends Control

onready var level_selector_node = $level_selector
onready var level_selector_box_node = $MarginContainer/VBoxContainer/HBoxContainer2/TextureRect2/ScrollContainer2/MarginContainer/level_selector_box
onready var chapter_box_node = $MarginContainer/VBoxContainer/HBoxContainer2/TextureRect/ScrollContainer/MarginContainer/ChapterBox

func back():
	hide()
	get_tree().call_group_flags(2, "update_data", "update_data")

func initialize(chap):
	chapter_box_node.initialize(chap)
	refresh_chapter(chap)
	
func refresh_chapter(chap):
	level_selector_node.chapitre = int(chap.replace("chapitre_", ""))
	level_selector_box_node.initialize(chap)
	
func load_with_param(param):
	initialize(param[0])
