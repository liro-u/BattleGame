extends Node
class_name dev_tool

onready var test_node = self.get_parent()
	
func _input(_event):
	if Input.is_action_just_pressed("dev_take_damage"):
		action1()
	elif Input.is_action_just_pressed("dev_grab_health"):
		action2()
	elif Input.is_action_just_pressed("dev_down_level"):
		action3()
	elif Input.is_action_just_pressed("dev_up_level"):
		action4()
		
		
func action1():
	test_node.add_case()

func action2():
	test_node.add_case(1)

func action3():
	test_node.del_case()
	test_node.add_case(1)

func action4():
	test_node.del_case()
	test_node.add_case()

