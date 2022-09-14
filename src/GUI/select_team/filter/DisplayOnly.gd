extends VBoxContainer

var element_filter = []
var type_filter = []
onready var element_node = $"DisplayOnlyBox/Element"
onready var type_node = $"DisplayOnlyBox/Type"
signal filter_change

var basic_color_button = Color("435666")
var element2color = {
	Element.Element.AIR:Color("a5fff9"),
	Element.Element.EARTH:Color("ffc981"),
	Element.Element.FIRE:Color("bd4f38"),
	Element.Element.WATER:Color("5c7ccf"),
	Element.Element.NONE:basic_color_button,
}

func _ready():
	for child in element_node.get_children():
		child.connect("element_pressed", self, "toggle_element")
	for child in type_node.get_children():
		child.connect("type_pressed", self, "toggle_type")
		
func toggle_element(element, button):
	if element_filter.has(element):
		element_filter.erase(element)
		button.self_modulate = basic_color_button
		button.get_child(0).set("custom_colors/font_color", Color("fff"))
	else:
		element_filter.append(element)
		button.self_modulate = element2color[element]
		button.get_child(0).set("custom_colors/font_color", Color("000"))
	emit_signal("filter_change")

func toggle_type(type, button):
	if type_filter.has(type):
		type_filter.erase(type)
		button.self_modulate = basic_color_button
		button.get_child(0).set("custom_colors/font_color", Color("fff"))
	else:
		button.self_modulate = Color("fff")
		button.get_child(0).set("custom_colors/font_color", Color("000"))
		type_filter.append(type)
	emit_signal("filter_change")

func display_only(battlers):
	var final_battlers = []
	for battler in battlers:
		if (element_filter.size() == 0 or element_filter.has(battler.stats_reference.element)) and (type_filter.size() == 0 or type_filter.has(battler.stats_reference.type)):
			final_battlers.append(battler)
	return final_battlers
