extends Control

onready var charact_selector = $charact_selector
onready var list_button = $"UI/ListeButton".get_children()
onready var leveldata_starter = $"UI/Start/Start/SwitchSceneData"
var list_char = [null,null,null]
var last_clicked = null
var battler_given = []

signal team_changed
	
func need_choose_player(button_ref):
	last_clicked = button_ref
	var exeptions = list_char.duplicate()
	while exeptions.has(null):
		exeptions.erase(null)
	charact_selector.initialize(exeptions, list_char[button_ref.get_parent().get_index()], battler_given.duplicate())
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
		child.get_child(0).reset()
	list_char = [null,null,null]
	last_clicked = null
	battler_given = []
