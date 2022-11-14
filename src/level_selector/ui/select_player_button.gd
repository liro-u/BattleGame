extends TextureButton
class_name chooseCharButton

onready var selected_battler_texture = $SelectedBattler
onready var data = $Data
onready var name_label = $"Data/Down/MarginContainer/Control/BattlerName"
onready var stars = $"Data/Up/Control/Stars"
onready var progressBar = $"Data/Down/Control/LevelProgressBar"
onready var overTexture = $"OverTexture"
onready var TypeTexture = $Data/Up/ClassType

export var color_element = {}
export(Texture) var basic_texture 
export(Texture) var disabled_texture
export(Color) var disabled_color
export(Color) var locked_color
signal want_change_char

func _init():
	connect("pressed", self, "want_change")

func want_change():
	emit_signal("want_change_char", self)

func reset():
	selected_battler_texture.texture = basic_texture
	selected_battler_texture.self_modulate = Color("fff")
	disabled = false
	show_data(false)

func show_data(need_show = true):
	if need_show:
		data.show()
	else:
		data.hide()

func locked_visible():
	disabled = true
	selected_battler_texture.self_modulate = locked_color
	
func disabled_visualy():
	selected_battler_texture.texture = disabled_texture
	selected_battler_texture.self_modulate = disabled_color
	
func initialize(data):
	selected_battler_texture.texture = data.stats_reference.hight_icon
	name_label.text = data.stats_reference.name_char
	var count = 0
	for child in stars.get_children():
		if count < data.stars:
			count += 1
			child.show()
		else:
			child.hide()
	var xp_needed = levelCalculation.xp_needed_for_level(data.level, data.stats_reference.starting_xp_needed, data.stats_reference.level_palier)
	progressBar.set_value(data.level)
	var xp_progress
	if data.xp == 0:
		xp_progress = 0
	else:
		xp_progress = clamp(data.xp / xp_needed * 1000, 0, 999)
	progressBar.set_progress(xp_progress)
	TypeTexture.texture = ElementTypeInfo.get_type_texture(data.stats_reference.type)
	TypeTexture.modulate = ElementTypeInfo.element_color[data.stats_reference.element]
	if data.locked:
		locked_visible()
	else:
		show_data()
	
