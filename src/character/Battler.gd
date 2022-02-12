tool
extends Node2D
class_name Battler

#-----------VARIABLES--------------#
#init
export var startingStats : Resource
export var ownerStats : Resource
export var team : int
#node path loaded
onready var character_gui : Control = $CharacterGUI
var clickable_area : ClickableArea
var mesh2D : GDDragonBones
var stats : BattlerStats

#--------------FUNCTION--------------#
#init
func _init() -> void:
	if mesh2D:
		mesh2D.queue_free()
	mesh2D = GDDragonBones.new()
	add_child(mesh2D)
	if stats:
		stats.queue_free()
	stats = BattlerStats.new()
	add_child(stats)
	if clickable_area:
		clickable_area.queue_free()
	clickable_area = ClickableArea.new()
	add_child(clickable_area)

#ready
func _ready() -> void:
	initialize()

#init
func initialize() -> void:
	stats.initialize(ownerStats, startingStats)
	mesh2D.resource = startingStats.ske
	clickable_area.collision_shape = startingStats.collision
	clickable_area.collision_position = startingStats.collision_position
	if team != 0:
		mesh2D.flipX = true
	mesh2D.scale = Vector2(0.1, 0.1)
	character_gui.initialize(self)
