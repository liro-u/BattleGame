extends Control

onready var list_char = $"TextureRect/MarginContainer/VBoxContainer/HBoxContainer2/ScrollContainer/MarginContainer/HBoxContainer"
onready var button_select = $"TextureRect/MarginContainer/VBoxContainer/HBoxContainer4/Button2"
onready var info_list = $"TextureRect/MarginContainer/VBoxContainer/HBoxContainer2/VBoxContainer"
onready var display_only = $"TextureRect/Filter/BackgroundFilter/Container/Box2"
onready var filter = $"TextureRect/Filter"
export var charact_path = "res://player_data/charact/"
var player = null
var already_select = null
var list_exeption = []
var selected_indicator
var start_battler_given = []
var battler_given = []

signal player_selected

func _ready():
	display_only.connect("filter_change", self, "reload_list_of_char")
	
func initialize(exeptions = [], asociate_select = null, given_battler = []):
	change_filter_visibility(false)
	button_select.text = "select"
	player = null
	list_exeption = exeptions
	already_select = asociate_select
	start_battler_given = given_battler
	selected_indicator = load("res://src/GUI/select_team/SelectedIndicator.tscn").instance()
	reload_list_of_char()
	
func reload_list_of_char():
	battler_given = start_battler_given.duplicate()
	
	if selected_indicator.get_parent():
		selected_indicator.get_parent().remove_child(selected_indicator)
		
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
	
	var new_select_char = load("res://src/GUI/select_team/selectChar.tscn")
	var list_char_button = []
	for file in files:
		battler_given.append(load("res://player_data/charact/" + file))
		
	battler_given = display_only.display_only(battler_given)
		
	for battler in battler_given:
		var new_controle = Control.new()
		var new_char_button = new_select_char.instance()
		new_controle.mouse_filter = MOUSE_FILTER_PASS
		new_char_button.mouse_filter = MOUSE_FILTER_PASS
		new_controle.add_child(new_char_button)
		list_char.add_child(new_controle)
		new_controle.rect_min_size = Vector2(140,280)
		new_char_button.rect_scale = Vector2(2,2)
		
		new_char_button.data_player = battler
		
		new_char_button.initialize(battler)
		new_char_button.show_data(true)
		
		new_char_button.connect("want_change_char", self, "player_clicked")
		
		list_char_button.append(new_char_button)
		
		
		player_clicked(list_char_button[0])

func player_clicked(player_selected):
	player = player_selected.data_player
	info_list.update_info(player)
	if selected_indicator.get_parent():
		selected_indicator.get_parent().remove_child(selected_indicator)
	player_selected.overTexture.add_child(selected_indicator)
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

func change_filter_visibility(vis_bool):
	filter.visible = vis_bool
