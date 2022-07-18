tool
extends TeamIconBattler
class_name TweenTeamIconBattler

var tween_move
var tween_alpha
var battler_properties

func _init():
	if tween_move:
		tween_move.queue_free()
	tween_move = CurveTween.new()
	add_child(tween_move)
	tween_move.connect("curve_tween", self, "set_pos")
	if tween_alpha:
		tween_alpha.queue_free()
	tween_alpha = CurveTween.new()
	add_child(tween_alpha)
	tween_alpha.connect("curve_tween", self, "set_alpha")

func set_pos(new_pos : Vector2):
	rect_position = new_pos

func set_alpha(new_value : float):
	modulate.a = new_value

func appear(time : float):
	tween_alpha.play(time, 0, 1)

func delete(time : float):
	tween_alpha.connect("tween_all_completed", self, "queue_free")
	tween_alpha.play(time, 1, 0)
