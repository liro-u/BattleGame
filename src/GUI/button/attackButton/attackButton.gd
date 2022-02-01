tool
extends "res://src/GUI/button/defaultButton/basicButton.gd"

var attack : Resource

func initialize():
	var value
	if attack and get_tree().get_nodes_in_group("active")[0].stats.mana >= attack.mana_cost and attack.element:
		value = attack.element.element
		disabled = false
		text = attack.attack_name
	else:
		value = "none"
		disabled = true
		text = ""
	set_background_color(value)
	_initialize()
	
		
func set_background_color(value):
	match value:
		"fire":
			background_color = Color.red
		"plant":
			background_color = Color.green * 0.5
			background_color.a = 1
		"water":
			background_color = Color.cadetblue
		"air":
			background_color = Color.aliceblue
		_:
			background_color = Color.gray
