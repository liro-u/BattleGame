extends Node
class_name ParentSwitchIndicator

signal need_changed_scene
signal need_switch_scene

func _init():
	add_to_group("parent_switcher_indicator")

func _ready():
	yield(get_parent(), "ready")
	for node in get_tree().get_nodes_in_group("switch_scene_data"):
		if node.switch:
			node.connect("need_switch_scene", self, "need_switch_scene")
		else:
			node.connect("need_switch_scene", self, "need_changed_scene")

func need_changed_scene(data_next_scene):
	emit_signal("need_changed_scene", get_parent(), data_next_scene)

func need_switch_scene(data_next_scene):
	emit_signal("need_switch_scene", get_parent(), data_next_scene)
