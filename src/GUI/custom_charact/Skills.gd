extends TextureRect

onready var list_atk = $Content/MarginContainer2/ScrollContainer/ATKLIST

func initialize(attack_list):
	var index = 0
	for attack in attack_list:
		var attack_node = list_atk.get_child(index)
		var attack_name = attack_node.get_node("ATKName")
		var attack_description = attack_node.get_node("ATKDescription")
		attack_name.text = attack.attack_name
		attack_description.text = attack.attack_description
		index += 1
	while index < 3:
		var attack_node = list_atk.get_child(index)
		attack_node.hide()
		index += 1
