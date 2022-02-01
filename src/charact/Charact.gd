tool
extends Node2D
class_name Charact

export(Resource) var basic_stats
export(Resource) var owner_stats
var mesh2D

func _init():
	mesh2D = Mesh2D.new()
	add_child(mesh2D)

func _ready():
	mesh2D.ske = basic_stats.ske
