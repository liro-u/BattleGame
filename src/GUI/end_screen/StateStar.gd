tool
extends TextureRect
class_name StateStar

export(Texture) var win_texture
export(Color) var win_color = Color(1,1,1,0)
export(Texture) var lose_texture
export(Color) var lose_color = Color(0,0,0,1)
export var timetween = 5

onready var particle = $Particles2D
onready var alphaTween = $AlphaTween

func _ready():
	initialize()
	
func initialize():
	hide()
	modulate.a = 0
	particle.position = rect_size / 2
	
func appear(is_finished : bool):
	if is_finished:
		texture = win_texture
		modulate = win_color
	else:
		texture = lose_texture
		modulate = lose_color
		particle.hide()
	modulate.a = 0
	show()
	alphaTween.play(timetween, 0, 1)
	


func set_alpha_with_tween(sat):
	modulate.a = sat
