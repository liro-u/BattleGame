tool
extends HBoxContainer

func initialize():
	for child in get_children():
		child._initialize()
