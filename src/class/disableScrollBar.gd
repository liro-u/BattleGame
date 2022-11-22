tool
extends ScrollContainer

export var h = true
export var v = false
export var scroll_value = 70

func _ready():
	if h:
		get_h_scrollbar().rect_scale.x = 0
	if v:
		get_v_scrollbar().rect_scale.x = 0

func add_v_scroll(mult = 1):
	scroll_vertical += scroll_value * mult
