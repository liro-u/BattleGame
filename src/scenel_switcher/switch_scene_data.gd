extends Node
class_name SwitchSceneData

export var next_scene_data = ["level", 1, 1]
export var switch = true
export var signal_name =  "pressed"

signal need_switch_scene

func _init():
	add_to_group("switch_scene_data")

func _ready():
	get_parent().connect(signal_name, self, "switch_level")

func switch_level():
	emit_signal("need_switch_scene", next_scene_data)
