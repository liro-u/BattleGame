tool
extends Node
class_name AttackList

#--------VARIABLES---------#
var active_attack = []

#--------FUNCTIONS------#
#init
func initialize(list_attack : Array) -> void:
	for child in get_children():
		child.queue_free()
		active_attack = []
	for attack in list_attack:
		var new_attack = Attack.new()
		add_child(new_attack)
		new_attack.initialize(attack)
		active_attack.append(new_attack)

func update_turn() -> void:
	for atk in get_children():
		atk.update_turn()
