extends HBoxContainer

var monnaie_data 

onready var textureNode = $TextureRect
onready var labelNode = $Label

func initialize(path):
	monnaie_data = load(path.replace("res://", Global.dataFolderPreset + "://"))
	textureNode.texture = monnaie_data.things.texture
	if (monnaie_data.things.group_updater != ""):
		add_to_group(monnaie_data.things.group_updater)
	update()
	

func update():
	var text_addition = " / " + str(monnaie_data.things.max_quantity)
	if monnaie_data.things.max_quantity < 0:
		text_addition = ""
	labelNode.text = str(monnaie_data.quantity) + text_addition
