tool
extends ScrollContainer

export var h = true
export var v = false
export var scroll_value = 70
export var duration = 1.0
onready var tween = $CurveTween
var scroll_value_waiting = 0
var pos_target

func _ready():
	if h:
		get_h_scrollbar().rect_scale.x = 0
	if v:
		get_v_scrollbar().rect_scale.x = 0

func add_v_scroll(mult = 1):
	scroll_value_waiting += scroll_value * mult
	pos_target = clamp(scroll_vertical + scroll_value_waiting, 0, get_child(0).rect_size.y - rect_size.y)
	tween.play(duration, scroll_vertical, pos_target)

func _on_CurveTween_curve_tween(sat):
	scroll_vertical = sat
	scroll_value_waiting = pos_target - scroll_vertical

