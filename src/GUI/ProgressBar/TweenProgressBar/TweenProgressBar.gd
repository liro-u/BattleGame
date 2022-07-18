tool
extends Control
class_name TweenProgressBar

#------------VARIABLES------------#
#down mode
var down_mode = true setget set_down_mode
#show value
export(bool) var show_value = false setget set_show_value
#color style
export(Color) var direct_color = Color(1, 0, 0) setget set_direct_color
export(Color) var down_color = Color(0.5, 0.5, 0.05) setget set_down_color
export(Color) var up_color = Color(0, 1, 0) setget set_up_color
#texture style
export(Texture) var basic_under_texture =  load("res://asset/GUI/lifebar/under.png") setget set_basic_under_texture
export(Texture) var basic_over_texture = load("res://asset/GUI/lifebar/over.png") setget set_basic_over_texture
export(Texture) var basic_progress_texture = load("res://asset/GUI/lifebar/progress.png") setget set_basic_progress_texture
export(bool) var null_under_texture = false setget set_null_under_texture
export(bool) var null_over_texture = false setget set_null_over_texture
export(bool) var null_progress_texture = false setget set_null_progress_texture
#size
export(Vector2) var size_rect = Vector2(700, 56) setget set_size_rect
export(Vector2) var scale_rect = Vector2(0.5, 0.5) setget set_scale_rect
#nine patch
export(int) var stretch_margin_left = 28 setget set_stretch_margin_left
export(int) var stretch_margin_right = 28 setget set_stretch_margin_right
export(int) var stretch_margin_top = 28 setget set_stretch_margin_top
export(int) var stretch_margin_bottom = 28 setget set_stretch_margin_bottom
export(bool) var nine_patch_stretch = true setget set_nine_patch_stretch
#value
export(int) var start_value = 100 setget set_start_value
var current_value : int
var max_value : int
var rest_value : int
#theme
export(Theme) var custom_theme = load("res://asset/theme/GUI.tres") setget set_theme
export(DynamicFont) var custom_font_progress_value = load("res://asset/font/dynamicfont/basic_font.tres").duplicate() setget set_custom_font_progress_value
export(Color) var custom_font_color_progress_value = Color.wheat setget set_custom_font_color_progress_value
#curve
export(Curve) var alpha_curve = load("res://asset/curve/ease_in.tres")
export(Curve) var value_curve = load("res://asset/curve/ease_in.tres")
#loaded node path
var over_progress_bar : TextureProgress
var under_progress_bar : TextureProgress
var value_tween : CurveTween
var alpha_tween : CurveTween
var value_label : Label
#switch node
var direct_progress_bar : TextureProgress
var tween_progress_bar : TextureProgress
#preview
export(int) var value_update = start_value setget update_tool
export(int) var duration = 1
#----------SIGNALE---------#
signal bar_is_empty(rest_value)
var signal_was_emit : bool = false
#-----------SETGET-------------#
#dev tool
func update_tool(new_value) -> void:
	if is_inside_tree():
		value_update = new_value
		update_value(value_update)

#set down mode
func set_down_mode(new_value : bool = down_mode) -> void:
	down_mode = new_value
	if down_mode:
		direct_progress_bar = over_progress_bar
		tween_progress_bar = under_progress_bar
	else:
		tween_progress_bar = over_progress_bar
		direct_progress_bar = under_progress_bar
	update_color()
#show value
func set_show_value(new_value : bool = show_value) -> void:
	show_value = new_value
	if show_value:
		value_label.show()
	else:
		value_label.hide()
#set start value
func set_start_value(new_value : int = start_value) -> void:
	start_value = new_value
	initialize()
#set theme
func set_theme(new_value : Theme = custom_theme) -> void:
	custom_theme = new_value
	theme = custom_theme
func set_custom_font_progress_value(new_value : DynamicFont = custom_font_progress_value) -> void:
	custom_font_progress_value = new_value
	value_label.set("custom_fonts/font", custom_font_progress_value)
func set_custom_font_color_progress_value(new_value : Color = custom_font_color_progress_value):
	custom_font_color_progress_value = new_value
	value_label.set("custom_colors/font_color", custom_font_color_progress_value)
#update value and mode
func update_value_and_mode() -> void:
	set_show_value()
	set_down_mode()
	set_start_value()
	set_theme()
	set_custom_font_progress_value()
	set_custom_font_color_progress_value()

#set direct color
func set_direct_color(new_value : Color = direct_color) -> void:
	direct_color = new_value
	over_progress_bar.tint_progress = direct_color
#set_down_color
func set_down_color(new_value : Color = down_color) -> void:
	down_color = new_value
	under_progress_bar.tint_progress = down_color
#set_down_color
func set_up_color(new_value : Color = up_color) -> void:
	up_color = new_value
	under_progress_bar.tint_progress = up_color
#update color
func update_color() -> void:
	set_direct_color()
	if down_mode:
		set_down_color()
	else:
		set_up_color()

#set under texture
func set_under_texture() -> void:
	var new_value
	if null_under_texture:
		new_value = null
	else:
		new_value = basic_under_texture
	under_progress_bar.texture_under = new_value
#set over texture
func set_over_texture() -> void:
	var new_value
	if null_over_texture:
		new_value = null
	else:
		new_value = basic_over_texture
	over_progress_bar.texture_over = new_value
#set progress texture
func set_progress_texture() -> void:
	var new_value
	if null_progress_texture:
		new_value = null
	else:
		new_value = basic_progress_texture
	tween_progress_bar.texture_progress = new_value
	direct_progress_bar.texture_progress = new_value
#set basic under texture
func set_basic_under_texture(new_value : Texture = basic_under_texture) -> void:
	basic_under_texture = new_value
	set_under_texture()
#set basic over texture
func set_basic_over_texture(new_value : Texture = basic_over_texture) -> void:
	basic_over_texture = new_value
	set_over_texture()
#set basic progress texture
func set_basic_progress_texture(new_value : Texture = basic_progress_texture) -> void:
	basic_progress_texture = new_value
	set_progress_texture()

	
#null under texture
func set_null_under_texture(new_value : bool) -> void:
	null_under_texture = new_value
	set_under_texture()
#null over texture
func set_null_over_texture(new_value : bool) -> void:
	null_over_texture = new_value
	set_over_texture()
#null progress texture
func set_null_progress_texture(new_value : bool) -> void:
	null_progress_texture = new_value
	set_progress_texture()
#update texture
func update_texture() -> void:
	set_under_texture()
	set_over_texture()
	set_progress_texture()

#set size rect
func set_size_rect(new_value : Vector2 = size_rect) -> void:
	size_rect = new_value
	tween_progress_bar.rect_size = size_rect
	direct_progress_bar.rect_size = size_rect
	set_min_rect_size()
#set scale rect
func set_scale_rect(new_value : Vector2 = scale_rect) -> void:
	scale_rect = new_value
	tween_progress_bar.rect_scale = scale_rect
	direct_progress_bar.rect_scale = scale_rect
	set_min_rect_size()
#set min rect size
func set_min_rect_size() -> void:
	rect_min_size = size_rect * scale_rect
	rect_size = rect_min_size
#update size
func update_size() -> void:
	set_size_rect()
	set_scale_rect()

#set stretch margin left
func set_stretch_margin_left(new_value : int = stretch_margin_left) -> void:
	stretch_margin_left = new_value
	tween_progress_bar.stretch_margin_left = stretch_margin_left
	direct_progress_bar.stretch_margin_left = stretch_margin_left
#set stretch margin right
func set_stretch_margin_right(new_value : int = stretch_margin_right) -> void:
	stretch_margin_right = new_value
	tween_progress_bar.stretch_margin_right = stretch_margin_right
	direct_progress_bar.stretch_margin_right = stretch_margin_right
#set stretch margin top
func set_stretch_margin_top(new_value : int = stretch_margin_top) -> void:
	stretch_margin_top = new_value
	tween_progress_bar.stretch_margin_top = stretch_margin_top
	direct_progress_bar.stretch_margin_top = stretch_margin_top
#set stretch margin bottom
func set_stretch_margin_bottom(new_value : int = stretch_margin_bottom) -> void:
	stretch_margin_bottom = new_value
	tween_progress_bar.stretch_margin_bottom = stretch_margin_bottom
	direct_progress_bar.stretch_margin_bottom = stretch_margin_bottom
#set nine patch stretch 
func set_nine_patch_stretch(new_value : bool = nine_patch_stretch) -> void:
	nine_patch_stretch = new_value
	tween_progress_bar.nine_patch_stretch = nine_patch_stretch
	direct_progress_bar.nine_patch_stretch = nine_patch_stretch
	#when set false then true the size is wrong (you can patch it if you change size)
#update ninepatch
func update_ninepatch() -> void:
	set_stretch_margin_left()
	set_stretch_margin_right()
	set_stretch_margin_top()
	set_stretch_margin_bottom()
	set_nine_patch_stretch()

#--------------FUNCTION-----------#
#init
func _init() -> void:
	#adding progress bar
	if under_progress_bar:
		under_progress_bar.queue_free()
	under_progress_bar = TextureProgress.new()
	add_child(under_progress_bar)
	if over_progress_bar:
		over_progress_bar.queue_free()
	over_progress_bar = TextureProgress.new()
	add_child(over_progress_bar)
	#define action
	tween_progress_bar = under_progress_bar
	direct_progress_bar = over_progress_bar
	#adding tween
	if value_tween:
		value_tween.queue_free()
	value_tween = CurveTween.new()
	add_child(value_tween)
	if alpha_tween:
		alpha_tween.queue_free()
	alpha_tween = CurveTween.new()
	add_child(alpha_tween)
	alpha_tween.curve = alpha_curve
	value_tween.curve = value_curve
	#adding label
	if value_label:
		value_label.queue_free()
	value_label = Label.new()
	over_progress_bar.add_child(value_label)
	value_label.align = true
	value_label.valign = true
	value_label.anchor_bottom = 1
	value_label.anchor_right = 1
	value_label.set_v_size_flags(3)
	value_label.set_h_size_flags(3)
	#update all
	update_ninepatch()
	update_texture()
	update_color()
	update_size()
	update_value_and_mode()
	alpha_tween.connect("curve_tween", self, "update_tween_alpha")
	value_tween.connect("curve_tween", self, "update_tween_value")

#init
func _ready() -> void:
	initialize()

#init value
func initialize(new_value : int = start_value) -> void:
	max_value = new_value
	tween_progress_bar.max_value = max_value
	direct_progress_bar.max_value = max_value
	set_value(max_value)

#calcul current and new value
func calcul_value(new_value : int) -> void:
	if new_value < 0:
		current_value = 0
		rest_value = new_value
	else:
		current_value = new_value
		rest_value = 0
#set value
func set_value(new_value : int) -> void:
	calcul_value(new_value)
	value_tween.remove_all()
	alpha_tween.remove_all()
	tween_progress_bar.tint_progress.a = 0
	tween_progress_bar.value = current_value
	direct_progress_bar.value = current_value
	update_value_label(current_value)
	
#update value label
func update_value_label(new_value : float) -> void:
	var print_value : int = round(new_value)
	print_value = clamp(print_value, 0, max_value)
	value_label.text = str(print_value) + "/" + str(max_value)
	check_positive_value(new_value)

func update_value(new_value : int) -> void:
	if current_value != new_value:
		if current_value > new_value:
			set_down_mode(true)
			alpha_tween.play(duration, 0.8, 0.35)
		else:
			alpha_tween.remove_all()
			set_down_mode(false)
		calcul_value(new_value)
		direct_progress_bar.value = current_value
		value_tween.play(duration, tween_progress_bar.value, current_value)

func update_tween_value(sat : float) -> void:
	tween_progress_bar.value = sat
	update_value_label(sat)

func update_tween_alpha(sat : float) -> void:
	tween_progress_bar.tint_progress.a = sat

func check_positive_value(value : float) -> void:
	if value <= 0 and !signal_was_emit:
		signal_was_emit = true
		emit_signal("bar_is_empty", rest_value)
