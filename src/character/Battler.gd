tool
extends Node2D
class_name Battler

#-----------VARIABLES--------------#
#init
export var startingStats : Resource
export var ownerStats : Resource
export var team : int
#node_path_loaded
onready var character_gui = $CharacterGUI
onready var clickable_area = $ClickableArea
var mesh2D
var stats

#--------------FUNCTION--------------#
#init
func _init() -> void:
	mesh2D = GDDragonBones.new()
	add_child(mesh2D)
	stats = BattlerStats.new()
	add_child(stats)

#ready
func _ready() -> void:
	initialize()

#init
func initialize() -> void:
	stats.initialize(ownerStats, startingStats)
	mesh2D.resource = startingStats.ske
	if team != 0:
		mesh2D.flipX = true
	mesh2D.scale = Vector2(0.2, 0.2)
