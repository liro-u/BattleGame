tool
extends HBoxContainer

signal button_pressed(nb)

func button_pressed(nb):
	emit_signal("button_pressed", nb)

func initialize():
	for child in get_children():
		child._initialize()
