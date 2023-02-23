extends Button

var task_data
onready var indicator = $HBoxContainer/TextureRect

func select():
	indicator.show()

func deselect():
	indicator.hide()
