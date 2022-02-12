extends Node
class_name dev_tool

onready var test_node = self.get_parent()
	
func _input(_event):
	if Input.is_action_just_pressed("dev_take_damage"):
		take_damage()
	elif Input.is_action_just_pressed("dev_grab_health"):
		up_health()
	elif Input.is_action_just_pressed("dev_down_level"):
		add_shield()
	elif Input.is_action_just_pressed("dev_up_level"):
		pass
		
		
func take_damage():
	test_node.stats.health_changed(-65)

func up_health():
	test_node.stats.health_changed(70)

func add_shield():
	test_node.stats.create_shield(300)
