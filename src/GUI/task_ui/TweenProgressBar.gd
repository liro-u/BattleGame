extends TextureProgress

export var duration = 1

onready var tween = $CurveTween

func initialize(n):
	max_value = n

func set_value(n):
	value = n

func tween_to_value(n):
	tween.play(duration, value, n)


func _on_CurveTween_curve_tween(sat):
	value = sat
