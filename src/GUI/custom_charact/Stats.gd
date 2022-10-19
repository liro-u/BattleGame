extends TextureRect

export var color_element = {}

#first data node
onready var list_stars_node = $Content/MarginContainer2/ScrollContainer/StatsData/FirstData/VBoxContainer/StarsList
onready var name_char_node = $Content/MarginContainer2/ScrollContainer/StatsData/FirstData/VBoxContainer/NameChar
onready var type_node = $Content/MarginContainer2/ScrollContainer/StatsData/FirstData/TypeBattler

#second data node
onready var level_progress_bar_node = $Content/MarginContainer2/ScrollContainer/StatsData/SecondData/LevelProgressBar

#third data node
onready var third_data_node = $Content/MarginContainer2/ScrollContainer/StatsData/MarginContainer/ThirdData

func initialize(data):
	#init stars
	for star in list_stars_node.get_children():
		star.hide()
	for i in range(0, data.stars):
		list_stars_node.get_child(i).show()
	#init name char
	name_char_node.text = data.stats_reference.name_char
	#init type texture
	type_node.texture = ElementTypeInfo.get_type_texture(data.stats_reference.type)
	type_node.self_modulate = ElementTypeInfo.element_color[data.stats_reference.element]
	#init progress bar level
	level_progress_bar_node.set_value(data.level)
	var xp_needed = levelCalculation.xp_needed_for_level(data.level, data.stats_reference.starting_xp_needed, data.stats_reference.level_palier)
	var xp_progress
	if data.xp == 0:
		xp_progress = 0
	else:
		xp_progress = clamp(data.xp / xp_needed * 1000, 0, 999)
	level_progress_bar_node.set_progress(xp_progress)
	#init stats data
	third_data_node.update_info(data)
