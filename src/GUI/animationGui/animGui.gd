extends Control
class_name AnimGUI

export var time : float = 0.25
export var curve : Resource = load("res://asset/GUI/animGui/anim_gui_curve.tres")
var is_hide = true
var is_processing = false setget set_is_processing
signal anim_completed
var anim_tween


func set_is_processing(new_value : bool = is_processing) -> void:
	is_processing = new_value

func _init():
	if anim_tween:
		anim_tween.queue_free()
	anim_tween = CurveTween.new()
	add_child(anim_tween)
	anim_tween.curve = curve
	anim_tween.connect("curve_tween", self, "_on_animTween_curve_tween")
	margin_top = 0
	connect("anim_completed", self, "anim_completed")

func change_visible_state() -> void:
	if !is_processing:
		is_processing = true
		if is_hide:
			is_hide = !is_hide
			yield(anim_tween.play(time, rect_position, rect_position - Vector2(0, rect_size.y)), "completed")
		else:
			is_hide = !is_hide
			yield(anim_tween.play(time, rect_position, rect_position + Vector2(0, rect_size.y)), "completed")
		emit_signal("anim_completed")
	yield(get_tree(), "idle_frame")

func _on_animTween_curve_tween(sat):
	rect_position = sat

func anim_completed():
	is_processing = false
