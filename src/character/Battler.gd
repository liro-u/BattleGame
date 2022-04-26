tool
extends Node2D
class_name Battler

#-----------VARIABLES--------------#
#init
var startingStats : Resource
export var ownerStats : Resource = null setget set_owner_stats
export(int, 0, 1) var team = 0
#node path loaded
onready var character_gui : Control = $Viewport/texture/CharacterGUI
onready var attack : Node = $attack_list
onready var turn_indicator : Position2D = $Viewport/texture/turn_indicator
onready var textureNode : Node2D = $Viewport/texture
onready var sprite : Sprite = $Sprite
onready var tween_mix_value : Tween = $TweenMixValue

var clickable_area : ClickableArea
var mesh2D : GDDragonBones
var stats : BattlerStats
export var max_mix_value : float = 0.8
export var time_to_shade : float = 0.5

#----------SETGET-----------#
func set_owner_stats(new_value : Resource = ownerStats) -> void:
	ownerStats = new_value
	if ownerStats:
		startingStats = ownerStats.stats_reference
		update_stats()
	else:
		startingStats = null

#--------------FUNCTION--------------#
#init
func _init() -> void:
	if stats:
		stats.queue_free()
	stats = BattlerStats.new()
	add_child(stats)
	if clickable_area:
		clickable_area.queue_free()
	clickable_area = ClickableArea.new()
	add_child(clickable_area)
	clickable_area.priority = 5
	clickable_area.connect("pressed", self, "area_is_clicked")

#ready
func _ready() -> void:
	if mesh2D:
		mesh2D.queue_free()
	mesh2D = GDDragonBones.new()
	textureNode.add_child(mesh2D)
	initialize()
	sprite.set_material(sprite.get_material().duplicate(true))

#init
func initialize() -> void:
	set_owner_stats()

func update_stats() -> void:
	if ownerStats and startingStats and mesh2D:
		stats.initialize(ownerStats, startingStats)
		mesh2D.resource = startingStats.ske
		clickable_area.collision_shape = startingStats.collision
		clickable_area.collision_position = startingStats.collision_position
		sprite.scale = Vector2(0.2, 0.2)
		mesh2D.flipX = (team == 1)
		mesh2D.set("playback/curr_animation", "idle")
		mesh2D.set("playback/play", true)
		call_deferred("timed_update_stats")

func timed_update_stats():
	if attack:
		attack.initialize(startingStats.attack_list)
	if character_gui:
		character_gui.update_stats(self)
		character_gui.initialize(self)

func ask_action_turn() -> void:
	get_tree().call_group("action_gui", "setup_with_charact", self)

func end_turn() -> void:
	attack.update_turn()

func area_is_clicked():
	get_tree().call_group_flags(2, "action_state", "set_gui", "end_turn")

func shade() -> void:
	tween_mix_value.play(time_to_shade, sprite.material.get("shader_param/mix_amount"), 0.8)

func unshade() -> void:
	tween_mix_value.play(time_to_shade, sprite.material.get("shader_param/mix_amount"), 0.0)

func set_mix_amount(sat):
	sprite.material.set("shader_param/mix_amount", sat)
