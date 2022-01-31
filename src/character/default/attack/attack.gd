tool
extends Node
class_name Attack

var attack_list

func initialize(stats):
	attack_list = stats.attack_list

func attack(attack_number, target):
	if attack_number <= attack_list.size():
		var attack_data = attack_list[attack_number]
		get_parent().stats.change_mana(attack_data.mana_cost)
		target.take_damage(attack_data)
		yield(get_parent().play_anim("attack"), "completed")
	else:
		print("ERROR: Unkow attack number")

func get_attack():
	return attack_list
