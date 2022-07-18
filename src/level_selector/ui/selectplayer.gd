extends TextureButton
class_name selectPlayer

signal player_selected
var data_player

func _init(min_size_init = Vector2(70, 140)):
	connect("pressed", self, "player_selected")
	expand = true
	rect_min_size = min_size_init
	stretch_mode = STRETCH_KEEP_ASPECT_COVERED
	

func player_selected():
	emit_signal("player_selected", data_player)
