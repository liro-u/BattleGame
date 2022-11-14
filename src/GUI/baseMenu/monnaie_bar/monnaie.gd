extends HBoxContainer

onready var textureNode = $TextureRect
onready var labelNode = $Label

func initialize(data):
	textureNode.texture = data.things.texture
	var text_addition = " / " + str(data.things.max_quantity)
	if data.things.max_quantity < 0:
		text_addition = ""
	labelNode.text = str(data.quantity) + text_addition
