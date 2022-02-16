tool
extends Control
class_name TeamIconBattler

#-------VARIABLES---------#
#nine patch
export(int) var nine_patch_value = 0 setget set_nine_patch_value
export(int) var margin_value = 0 setget set_margin_value
export(bool) var keep_ratio = true setget set_keep_ratio
#custom theme
export(Texture) var back_texture = load("res://asset/GUI/turnline/fond.png") setget set_back_texture
export(Color) var back_color = Color.darkred setget set_back_color
export(Texture) var profil_texture = load("res://asset/chararacters/001_testChar/icon.png") setget set_profil_texture
export(Texture) var border_texture = load("res://asset/GUI/turnline/cadre.png") setget set_border_texture
export(Color) var border_color = Color.red setget set_border_color
#loaded node path
var back
var profil
var border
var margin_profil

#------SETGET-------#
#set nine patch
func set_nine_patch_value(new_value : int = nine_patch_value) -> void:
	nine_patch_value = new_value
	set_nine_patch(back)
	set_nine_patch(border)
func set_nine_patch(node) -> void:
	node.patch_margin_left = nine_patch_value
	node.patch_margin_right = nine_patch_value
	node.patch_margin_top = nine_patch_value
	node.patch_margin_bottom = nine_patch_value

#set keep ratio
func set_keep_ratio(new_value : bool = keep_ratio) -> void:
	keep_ratio = new_value
	check_keep_ratio()

#set nine patch
func set_margin_value(new_value : int = margin_value) -> void:
	margin_value = new_value
	margin_profil.set("custom_constants/margin_right", margin_value)
	margin_profil.set("custom_constants/margin_left", margin_value)
	margin_profil.set("custom_constants/margin_top", margin_value)
	margin_profil.set("custom_constants/margin_bottom", margin_value)

#set color
func set_back_color(new_value : Color = back_color) -> void:
	back_color = new_value
	back.modulate = back_color
func set_border_color(new_value : Color = border_color) -> void:
	border_color = new_value
	border.modulate = border_color

#set texture
func set_back_texture(new_value : Texture = back_texture) -> void:
	back_texture = new_value
	back.texture = back_texture
func set_border_texture(new_value : Texture = border_texture) -> void:
	border_texture = new_value
	border.texture = border_texture
func set_profil_texture(new_value : Texture = profil_texture) -> void:
	profil_texture = new_value
	profil.texture = profil_texture


func update_all():
	set_nine_patch_value()
	set_back_color()
	set_border_color()
	set_back_texture()
	set_border_texture()
	set_profil_texture()
	set_margin_value()
	set_keep_ratio()

#---------FUNCTIONS------#
#init
func _init() -> void:
	if back:
		back.queue_free()
	back = NinePatchRect.new()
	add_child(back)
	back.anchor_right = 1
	back.anchor_bottom = 1
	if margin_profil:
		margin_profil.queue_free()
	margin_profil = MarginContainer.new()
	add_child(margin_profil)
	margin_profil.anchor_right = 1
	margin_profil.anchor_bottom = 1
	if profil:
		profil.queue_free()
	profil = TextureRect.new()
	margin_profil.add_child(profil)
	profil.anchor_right = 1
	profil.anchor_bottom = 1
	profil.stretch_mode = 6
	profil.expand = true
	if border:
		border.queue_free()
	border = NinePatchRect.new()
	add_child(border)
	border.anchor_right = 1
	border.anchor_bottom = 1
	connect("resized", self, "check_keep_ratio")

#ready
func _ready() -> void:
	initialize()

#init
func initialize() -> void:
	update_all()

func check_keep_ratio() -> void:
	if keep_ratio:
		if rect_size.x > rect_size.y:
			rect_size.y = rect_size.x
		else:
			rect_size.x = rect_size.y
