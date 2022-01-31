tool
extends Control

export var direct_color = Color(1, 0, 0)
export var down_color = Color(0.5, 0.5, 0.05)
export var up_color = Color(0, 1, 0)

export var show_value = false
export var size_rect = Vector2(700, 56)
export var scale_rect = Vector2(0.5, 0.5)

onready var over_progress_bar = $OverProgressBar
onready var under_progress_bar = $UnderProgressBar
onready var value_tween = $ValueCurveTween
onready var alpha_tween = $AlphaCurveTween
onready var value_label = $value

var max_value = 0
var current_value = 0

var direct_progress_bar
var progress_bar

func initialize(start_value : int):
	if show_value:
		value_label.show()
	else:
		value_label.hide()
	init_value(start_value)
	over_progress_bar.tint_progress = direct_color
	over_progress_bar.rect_scale = scale_rect
	under_progress_bar.rect_scale = scale_rect
	over_progress_bar.rect_size = size_rect
	under_progress_bar.rect_size = size_rect
	rect_min_size = size_rect * scale_rect
	rect_size = rect_min_size
	
func init_value(start_value : int):
	max_value = start_value
	under_progress_bar.max_value = start_value
	over_progress_bar.max_value = start_value
	set_value(start_value)

func set_value(new_value : int):
	current_value = new_value
	value_tween.remove_all()
	alpha_tween.remove_all()
	under_progress_bar.tint_progress.a = 0
	under_progress_bar.value = new_value
	over_progress_bar.value = new_value
	update_value_label(new_value)
	
func update_value_label(new_value):
	value_label.text = str(round(new_value)) + "/" + str(max_value)
	
func update_value(new_value : int):
	if current_value != new_value:
		if current_value > new_value:
			under_progress_bar.tint_progress = down_color
			direct_progress_bar = over_progress_bar
			progress_bar = under_progress_bar
			alpha_tween.play(1, 0.8, 0.35)
		else:
			alpha_tween.remove_all()
			under_progress_bar.tint_progress = up_color
			under_progress_bar.tint_progress.a = 0.8
			direct_progress_bar = under_progress_bar
			progress_bar = over_progress_bar
		current_value = new_value
		direct_progress_bar.value = new_value
		value_tween.play(1, progress_bar.value, new_value)
	
func _on_ValueCurveTween_curve_tween(sat):
	progress_bar.value = sat
	update_value_label(sat)

func _on_AlphaCurveTween_curve_tween(sat):
	progress_bar.tint_progress.a = sat

