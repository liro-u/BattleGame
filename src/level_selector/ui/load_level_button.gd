extends Button

onready var level_data_switcher = $"SwitchSceneData"

signal load_level

func _init():
	connect("pressed", self, "load_level")

func load_level():
	if SaverInventory.tryRemoveStamina(0) and level_data_switcher.next_scene_data[3].size() > 0:
		emit_signal("load_level")
