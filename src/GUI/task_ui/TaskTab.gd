extends Button

var task_data
onready var indicator = $TextureRect

func select():
	indicator.show()
	set("custom_colors/font_color", Color("#000"))

func deselect():
	indicator.hide()
	set("custom_colors/font_color", Color("#fff"))
