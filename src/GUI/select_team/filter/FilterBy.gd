extends VBoxContainer

onready var list_button = $"SortByBox"
onready var toggle_filter_by_condition = $"../../../../ButtonContainer/VBoxContainer/TopButtonContainer/level"
onready var filter_direction_indicator = $"../../../../ButtonContainer/VBoxContainer/TopButtonContainer/Control/DirIndicator"
export var basic_color_button = Color("435666")
var filter_tag = "level"
var last_button = null
var filter_direction = false
signal filter_change

class CustomSorter:
	var filter_direction = false
		
	func _init(BoolDir = false):
		filter_direction = BoolDir
	
	func filter_by_level(a, b):
		if filter_direction:
			if a.level < b.level:
				return true
		else:
			if a.level > b.level:
				return true
		return false
		
	func filter_by_type(a, b):
		if filter_direction:
			if a.stats_reference.type < b.stats_reference.type:
				return true
		else:
			if a.stats_reference.type > b.stats_reference.type:
				return true
		return false

	func filter_by_element(a, b):
		if filter_direction:
			if a.stats_reference.element < b.stats_reference.element:
				return true
		else:
			if a.stats_reference.element > b.stats_reference.element:
				return true
		return false
		
	func filter_by_rank(a, b):
		if filter_direction:
			if a.stars < b.stars:
				return true
		else:
			if a.stars > b.stars:
				return true
		return false
	
	func filter_by_unlocked(a, b):
		if a.locked == b.locked:
			return true
		elif a.locked and not b.locked:
			return false
		return true
		
func _ready():
	for child in list_button.get_children():
		child.connect("filter_by_pressed", self, "toggle_filter_condition")
	toggle_filter_by_condition.connect("pressed", self, "toggle_filter_condition")
	var but = list_button.get_child(0)
	toggle_filter_condition(but.tag, but)

func toggle_filter_condition(tag = filter_tag, button = last_button):
	filter_tag = tag
	toggle_filter_by_condition.text = tag
	if last_button != null:
		if last_button != button:
			last_button.self_modulate = basic_color_button
			last_button.get_child(0).set("custom_colors/font_color", Color("fff"))
		else:
			filter_direction = !filter_direction
	if filter_direction:
		filter_direction_indicator.rect_rotation = -90
	else:
		filter_direction_indicator.rect_rotation = 90
	button.self_modulate = Color("fff")
	button.get_child(0).set("custom_colors/font_color", Color("000"))
	last_button = button
	
	emit_signal("filter_change")

func filter_by(battlers):
	match filter_tag:
		"level":
			battlers.sort_custom(CustomSorter.new(filter_direction), "filter_by_level")
		"type":
			battlers.sort_custom(CustomSorter.new(filter_direction), "filter_by_type")
		"element":
			battlers.sort_custom(CustomSorter.new(filter_direction), "filter_by_element")
		"rank":
			battlers.sort_custom(CustomSorter.new(filter_direction), "filter_by_rank")
	battlers.sort_custom(CustomSorter.new(), "filter_by_unlocked")
	return battlers
