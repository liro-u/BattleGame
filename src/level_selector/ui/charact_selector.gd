extends Control

onready var list_char = $"TextureRect/CenterContainer/VBoxContainer/ScrollContainer/MarginContainer/HBoxContainer"
onready var button_select = $"TextureRect/CenterContainer/VBoxContainer/HBoxContainer/Button2"
export var charact_path = "res://player_data/charact/"
var player = null
var already_select = null
var list_exeption = []

signal player_selected

func initialize(exeptions = [], asociate_select = null, battler_given = []):
	button_select.text = "select"
	player = null
	list_exeption = exeptions
	already_select = asociate_select
	for child in list_char.get_children():
		child.queue_free()
	
	var files = []
	var dir = Directory.new()
	dir.open(charact_path)
	dir.list_dir_begin()
	
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append(file)
	dir.list_dir_end()
	
	for file in files:
		battler_given.append(load("res://player_data/charact/" + file))
	for battler in battler_given:
		var new_char_button = selectPlayer.new()
		new_char_button.data_player = battler
		new_char_button.texture_normal = new_char_button.data_player.stats_reference.hight_icon
		list_char.add_child(new_char_button)
		new_char_button.connect("player_selected", self, "player_clicked")

func player_clicked(player_selected):
	player = player_selected
	if already_select == player:
		button_select.text = "unselect"
	else:
		button_select.text = "select"
	

func back():
	hide()

func togle_select():
	if player:
		emit_signal("player_selected", player)
		back()
