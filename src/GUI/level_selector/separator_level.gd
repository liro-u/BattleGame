extends HBoxContainer

onready var texture = $NinePatchRect

func set_left_to_right():
	texture.flip_h = true
	
func set_right_to_left():
	texture.flip_h = false
