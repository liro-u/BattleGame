tool
extends ScrollContainer

export var h = true
export var v = false

func _ready():
	if h:
		get_h_scrollbar().rect_scale.x = 0
	if v:
		get_v_scrollbar().rect_scale.x = 0
