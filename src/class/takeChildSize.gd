tool
extends Control

func _ready():
	apply_child_size()
	
func apply_child_size():
	rect_min_size = get_child(0).rect_min_size
	
