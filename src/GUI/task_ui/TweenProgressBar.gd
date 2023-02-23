extends TextureProgress

export var duration = 1.0

onready var tween = $CurveTween

func initialize(n):
	max_value = n

func set_value(n):
	value = n

func stop_all():
	tween.stop_all()
	tween.remove_all()

func tween_to_value(n):
	if (tween.is_active()):
		stop_all()
	tween.play(duration, value, n)


func _on_CurveTween_curve_tween(sat):
	value = sat
