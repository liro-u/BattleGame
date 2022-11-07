extends Control

onready var tab_node = $MarginContainer/HBoxContainer/Tab
onready var splash_node = $MarginContainer/HBoxContainer/VSeparator/SplashArt

var active_char
var index_char
var list_char = []
	
func initialize():
	tab_node.initialize(active_char)
	splash_node.texture = active_char.stats_reference.splash_art

func update_list(new_list):
	if new_list.size():
		list_char = new_list

func update_char(index):
	if index < list_char.size():
		active_char = list_char[index]
		index_char = index
		initialize()
		
func get_next_or_prev(add = 1):
	if list_char.size() > 1:
		index_char = (index_char + add) % list_char.size()
		active_char = list_char[index_char]
		initialize()

func back():
	hide()
