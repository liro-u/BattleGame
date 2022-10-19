extends Control

export(Color) var selected_color
export(Color) var base_color
export(NodePath) onready var starting_tab_path

onready var stats_node = $Stats
onready var skills_node = $Skills
onready var story_node = $Story

onready var active_tab = story_node

func _ready():
	set_tab_to_main(get_node(starting_tab_path))

func initialize(data):
	stats_node.initialize(data)
	skills_node.initialize(data.stats_reference.attack_list)
	story_node.initialize(data.stats_reference.information_battler)
	
func set_tab_to_main(new_tab):
	if active_tab:
		active_tab.self_modulate = base_color
		var label = active_tab.get_node("Content/HBoxContainer/Label")
		label.add_color_override("font_color", Color("000"))
		label.add_color_override("font_color_hover", Color("fff"))
	if new_tab:
		active_tab = new_tab
		active_tab.raise()
		active_tab.self_modulate = selected_color
		var label = active_tab.get_node("Content/HBoxContainer/Label")
		label.add_color_override("font_color", Color("fff"))
		label.add_color_override("font_color_hover", Color("000"))
		
