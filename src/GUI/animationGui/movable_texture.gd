tool
extends Control
class_name MovableTexture

export var rotate : float = 0
export var basic_size : Vector2 = Vector2(50, 50)
export var base_texture : Texture = load("res://asset/GUI/turnline/arrow.png")
export var base_curve : Curve = load("res://asset/GUI/animGui/turn_indicator_curve.tres")

export var duration : float = 1.0
export var start_at : Vector2 = Vector2(0, 0)
export var end_at : Vector2 = Vector2(0, 0)

export var state_is_start = true
var tween_node
var texture_node
var is_starting = true

func _init(init_start_at = start_at, init_end_at = end_at, init_duration = duration, init_size = basic_size, init_texture = base_texture, init_curve = base_curve):
	texture_node = TextureRect.new()
	texture_node.expand = true
	basic_size = init_size
	add_child(texture_node)
	if tween_node:
		tween_node.queue_free()
	tween_node = CurveTween.new()
	base_curve = init_curve
	start_at = init_start_at
	end_at = init_end_at
	duration = init_duration
	add_child(tween_node)
	tween_node.connect("curve_tween", self, "update_pos")
	tween_node.connect("tween_all_completed", self, "restart")

func _ready():
	texture_node.rect_size = basic_size
	texture_node.texture = base_texture
	tween_node.curve = base_curve
	if texture_node.rect_size != Vector2.ZERO:
		texture_node.rect_pivot_offset = texture_node.rect_size / 2
	texture_node.rect_rotation = rotate
	rect_min_size = texture_node.rect_size
	if state_is_start:
		texture_node.rect_position = start_at
	else:
		texture_node.rect_position = end_at
	if (start_at != end_at):
		play()

func play():
	if state_is_start:
		tween_node.call_deferred("play" ,duration, texture_node.rect_position, end_at)
	else:
		tween_node.call_deferred("play" ,duration, texture_node.rect_position, start_at)

func update_pos(sat):
	texture_node.rect_position = sat

func restart():
	if (start_at != end_at):
		state_is_start = ! state_is_start
		play()
