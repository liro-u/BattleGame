tool
extends Control

var current_state

onready var button_list = $TextureRect/ButtonList
onready var button_list_attack = button_list.get_node("HBoxContainer/ButtonListAttack")
onready var message = $TextureRect/Message
onready var selectable = $TextureRect/selectable
onready var button_list_action = button_list.get_node("HBoxContainer/ButtonListAction")
onready var button_list_selectable = selectable.get_node("buttonList")

var current_char
var current_attack
var current_target

func initialize(charact):
	current_char = charact
	if charact.team == 0:
		change_state("button")
		button_list_attack.initialize(current_char.startingStats.attack_list)
		button_list_action.initialize()
		button_list_selectable.initialize()
	else:
		#bot choice
		change_state("message")
		message.set_text(["opponent turn", "choosing action..."])
		yield(get_tree().create_timer(1.5), "timeout")
		var list_attack = charact.attack.get_attack().duplicate()
		var no_attack_ready = true
		var nb
		while list_attack.size() > 0 and no_attack_ready:
			nb = randi()%list_attack.size()
			if list_attack[nb].mana_cost <= charact.stats.mana:
				no_attack_ready = false
				current_attack = nb
			else:
				list_attack.remove(nb)
		if no_attack_ready:
			#recharger
			button_pressed(4)
		else:
			var target_list = []
			var temp_target
			for charact in get_tree().get_nodes_in_group("charact"):
				temp_target = charact.clickable_area.can_be_selected(current_char.team, current_char.stats.attack_list[current_attack].for_team)
				if temp_target:
					target_list.append(temp_target)
			if target_list.size() > 0:
				nb = randi()%target_list.size()
				target_selected(target_list[nb])
			else:
				#recharger
				button_pressed(4)
				
func change_state(state):
	hide_state(current_state)
	current_state = state
	show_state(current_state)
	
func hide_state(state):
	match state:
		"message":
			message.hide()
		"button":
			button_list.hide()
		"select_target":
			selectable.hide()
			
func show_state(state):
	match state:
		"message":
			message.show()
		"button":
			button_list.show()
		"select_target":
			selectable.show()
		
func button_pressed(nb):
	if nb < button_list_attack.get_child_count():
		current_attack = nb
		for charact in get_tree().get_nodes_in_group("charact"):
			charact.clickable_area.can_be_selected(current_char.team, current_char.stats.attack_list[current_attack].for_team)
		change_state("select_target")
	else:
		change_state("message")
		var text1
		if current_char.team == 0:
			text1 = "player turn"
		else:
			text1 = "opponent turn"
		message.set_text([text1, "recharge de mana en cour"])
		current_char.stats.change_mana(-65)
		yield(get_tree().create_timer(1.5), "timeout")
		get_parent().turn_queue.play_turn()
		
func back_to_attack():
	change_state("button")
	for charact in get_tree().get_nodes_in_group("charact"):
			charact.clickable_area.can_be_selected()
	
func target_selected(target):
	current_target = target
	change_state("message")
	var text1
	var text2
	if current_char.team == 0:
		text1 = "player turn"
	else:
		text1 = "opponent turn"
	text2 = "%s use %s on %s" % [current_char.stats.name_char, current_char.stats.attack_list[current_attack].attack_name, current_target.stats.name_char] 
	message.set_text([text1, text2])
	yield(current_char.attack.attack(current_attack, current_target), "completed")
	get_parent().turn_queue.play_turn()
