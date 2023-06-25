extends VBoxContainer

func update_info(attack_list):
	var index = 0
	for attack in attack_list:
		var attack_node = get_child(index)
		var attack_name = attack_node.get_node("attackName")
		var attack_description = attack_node.get_node("attackDescription")
		attack_name.text = attack.attack_name
		attack_description.text = attack.attack_description
		index += 1
	while index < 3:
		var attack_node = get_child(index)
		attack_node.hide()
		index += 1
