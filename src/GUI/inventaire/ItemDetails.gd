extends TextureRect

onready var textureObj = $"MarginContainer/VBoxContainer/HBoxContainer/TextureRect/MarginContainer/TextureRect"
onready var nameLabel = $"MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/Label"
onready var descriptionLabel = $"MarginContainer/VBoxContainer/VBoxContainer/Label2"
onready var useButton = $"MarginContainer/VBoxContainer/CenterContainer/Button"

func init(possession):
	var obj = possession.things
	textureObj.texture = obj.texture
	nameLabel.text = obj.things_name
	descriptionLabel.text = obj.description
	print(possession)

