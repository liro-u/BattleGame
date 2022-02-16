tool
extends Node2D
class_name Battler

#-----------VARIABLES--------------#
#init
var startingStats : Resource
export var ownerStats : Resource = null setget set_owner_stats
export(int, 0, 1) var team = 0
#node path loaded
onready var character_gui : Control = $CharacterGUI
var clickable_area : ClickableArea
var mesh2D : GDDragonBones
var stats : BattlerStats

#----------SETGET-----------#
func set_owner_stats(new_value : Resource = ownerStats) -> void:
	ownerStats = new_value
	if ownerStats:
		startingStats = ownerStats.stats_reference
		update_stats()
	
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
	set_owner_stats()
	if ownerStats and startingStats:
		character_gui.initialize(self)

func update_stats() -> void:
	stats.initialize(ownerStats, startingStats)
	mesh2D.resource = startingStats.ske
	clickable_area.collision_shape = startingStats.collision
	clickable_area.collision_position = startingStats.collision_position
	mesh2D.scale = Vector2(0.1, 0.1)
	mesh2D.flipX = (team == 1)
	if character_gui:
		character_gui.update_stats(self)
