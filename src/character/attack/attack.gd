tool
extends Node
class_name Attack

#--------VARIABLES---------#
export(Resource) var base_attack_data
var mana_cost = 0
var element = Element.Element.NONE
var turn_needed = 0
var actual_turn = 0
var target_enemy = true
var team_modifier_list = []
var enemy_modifier_list = []

#--------FUNCTIONS------#
#init
func initialize(attack_data) -> void:
	base_attack_data = attack_data
	mana_cost = base_attack_data.mana_cost
	element = base_attack_data.element
	turn_needed = base_attack_data.turn_needed
	actual_turn = base_attack_data.actual_turn
	
	target_enemy = base_attack_data.team_target_ennemy
	team_modifier_list = base_attack_data.modifiers_for_team
	enemy_modifier_list = base_attack_data.modifiers_for_enemy

func update_turn() -> void:
	if turn_needed > 0:
		if actual_turn > 0:
			actual_turn -= 1

func ask_use_attack() -> void:
	if turn_needed > 0:
		if actual_turn <= 0:
			actual_turn = turn_needed
	add_to_group("active_attack")
	get_tree().call_group("action_state", "set_gui", "select_target")

func use_attack() -> void:
	pass
