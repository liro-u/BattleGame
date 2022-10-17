extends Control
class_name LootNode

export var speed = 0.2

onready var tween = $CurveTween
onready var particle = $Particles2D
onready var texture = $LootNode

func _ready():
	texture.rect_size = Vector2(0, 0)
	particle.emitting = false
	
func appear():
	tween.play(speed, texture.rect_size, rect_size)
	particle.emitting = true
	
func disappear():
	tween.play(speed, texture.rect_size, Vector2(0, 0))
	particle.emitting = false

func tween_callBack(sat):
	texture.rect_size = sat
	texture.rect_min_size = sat
