extends Button

var task_list = []
onready var indicator = $HBoxContainer/TextureRect

func select():
	indicator.show()

func deselect():
	indicator.hide()
