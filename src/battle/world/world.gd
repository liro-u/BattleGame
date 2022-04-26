tool
extends Node2D
class_name BattleWorld

#------VARIABLES---------#
export var world : Resource
export(Array, Resource) var list_player_battler
export(Array, Resource) var list_enemy_battler

#loaded node path
onready var battleGUI = $battleGUI
var turn_queue : TurnQueue
var spawn_position : SpawnPosition
var back_ui_cancel : Area2D

export(PackedScene) var battler_scene

#---------FUNCTIONS-----#
#init
func _init() -> void:
	if back_ui_cancel:
		back_ui_cancel.queue_free()
	back_ui_cancel = ClickableArea.new()
	var rec = RectangleShape2D.new()
	rec.extents = Vector2(512, 300)
	back_ui_cancel.collision_shape = rec
	back_ui_cancel.collision_position = Vector2(512, 300)
	back_ui_cancel.add_to_group("ui_cancel")
	back_ui_cancel.is_under = true
	add_child(back_ui_cancel)

	if spawn_position:
		spawn_position.queue_free()
	spawn_position = SpawnPosition.new()
	add_child(spawn_position)
	if turn_queue:
		turn_queue.queue_free()
	turn_queue = TurnQueue.new()
	add_child(turn_queue)

func add_battler(list_battler: Array, team : int = 0) -> void:
	if list_battler.size() > 0:
		for battler in list_battler:
			var new_battler = battler_scene.instance()
			new_battler.team = team
			new_battler.ownerStats = battler
			turn_queue.add_child(new_battler)

#ready
func _ready() -> void:
	initialize()

#init
func initialize() -> void:
	add_child(world.aspect.instance())
	spawn_position.team_pos = world.team_pos
	spawn_position.enemy_pos = world.enemy_pos
	
	add_battler(list_enemy_battler, 1)
	add_battler(list_player_battler)
	
	spawn_position.initialize(turn_queue.get_children())
	turn_queue.initialize()
	battleGUI.initialize(turn_queue)
	back_ui_cancel.call_deferred("initialize")
