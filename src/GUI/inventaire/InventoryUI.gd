extends Control

onready var item_box = $UI/VBoxContainer/BottomPart/ItemBox

func initialize():
	item_box.initialize()

func back():
	hide()
