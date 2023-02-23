extends Control

onready var list_button = $"UI/ListeButton".get_children()
onready var leveldata_starter = $"UI/Start/MarginContainer/VBoxContainer/Start/SwitchSceneData"
var list_char = [null,null,null]
var last_clicked = null
var battler_given = [] setget set_battler_given

signal team_changed

func _ready():
	for ui in get_tree().get_nodes_in_group("charact_selector_ui"):
		ui.connect("player_selected", self, "player_selected")

func set_battler_given(new_value = battler_given.duplicate()):
	battler_given = new_value
	for i in range (0, new_value.size()):
		battler_given[i].is_given = true
	
func need_choose_player(button_ref):
	last_clicked = button_ref
	var exeptions = list_char.duplicate()
	while exeptions.has(null):
		exeptions.erase(null)
	for charact_selector in get_tree().get_nodes_in_group("charact_selector_ui"):
		charact_selector.initialize(exeptions, list_char[button_ref.get_parent().get_index()], battler_given.duplicate(), false, true)
		charact_selector.show()

func player_selected(player):
	if list_char[last_clicked.get_parent().get_index()] == player:
		#unselect
		last_clicked.reset()
		list_char[last_clicked.get_parent().get_index()] = null
	else:
		if list_char.has(player):
			#delete existing
			var index = list_char.find(player)
			list_button[index].get_child(0).reset()
			list_char[index] = null
		#add new
		last_clicked.initialize(player)
		list_char[last_clicked.get_parent().get_index()] = player
		last_clicked.show_data(true)
	var new_team = list_char.duplicate()
	while new_team.has(null):
		new_team.erase(null)
	leveldata_starter.next_scene_data[3] = new_team
	
func back():
	hide()

func reset():
	for child in list_button:
		var node = child.get_child(0)
		node.reset()
		node.disabled = false
	list_char = [null,null,null]
	last_clicked = null
	battler_given = []

func set_team(team):
	list_char = team.duplicate()
	leveldata_starter.next_scene_data[3] = list_char.duplicate()
	#update visual
	var index = 0
	for child in list_button:
		var node = child.get_child(0)
		node.disabled = true
		if list_char.size() > index:
			node.initialize(list_char[index])
			print(index)
			index += 1
		else:
			node.disabled_visualy()
