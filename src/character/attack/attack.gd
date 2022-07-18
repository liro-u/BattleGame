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

func ask_use_attack(skip_call = false) -> void:
	if turn_needed > 0:
		if actual_turn <= 0:
			actual_turn = turn_needed
	add_to_group("active_attack")
	if !skip_call:
		get_tree().call_group("action_state", "set_gui", "select_target")

func use_attack() -> void:
	var active_battler = get_tree().get_nodes_in_group("turn_queue")[0].active_battler
	active_battler.stats.mana_changed(-mana_cost)
	add_modifier(team_modifier_list, true)
	add_modifier(enemy_modifier_list, false)

func add_modifier(modifier_list, target_team = false):
	var active_battler = get_tree().get_nodes_in_group("turn_queue")[0].active_battler
	for modifier in modifier_list:
		var temp_mod = change_modifier(active_battler, modifier.duplicate())
		#si multi_target est true alors je recupere toute l'equipe
		if modifier.multi_target:
			for node in get_tree().get_nodes_in_group("charact"):
				#team
				if ((node.team == active_battler.team) == target_team):
					node.add_modifier(temp_mod)
		#si multi_target est false alors je recupere le battler clicker
		else:
			if target_enemy != target_team:
				get_tree().get_nodes_in_group('target_battler')[0].add_modifier(temp_mod)
			else:
				if target_enemy:
					active_battler.add_modifier(temp_mod)
				else:
					var list_enemy_node = []
					for node in get_tree().get_nodes_in_group("charact"):
						if (node.team != active_battler.team):
							list_enemy_node.append(node)
					var random_enemy_node = list_enemy_node[randi() % list_enemy_node.size()]
					random_enemy_node.add_modifier(temp_mod)
	get_tree().call_group_flags(2, "action_state", "set_gui", "end_turn")

func change_modifier(activ_battler, mod):
	if mod.health < 0:
		var mult_element = 1
		if mod.with_weakness:
			mult_element = float(ElementCalculation.element_calculation(mod.element, activ_battler.startingStats.element))
		var crit_mult = 1
		if mod.with_crit and (activ_battler.stats.crit >= (randf() * 100)):
			crit_mult = activ_battler.stats.crit_mult
		else:
			mod.with_crit = false
		mod.health = mult_element * mod.health * activ_battler.stats.strength * crit_mult / 30
	else:
		mod.with_crit = false
		mod.health = mod.health * activ_battler.stats.magie / 30
	if mod.shield > 0:
		mod.shield = mod.shield * activ_battler.stats.magie / 30
	else:
		pass
	return mod
