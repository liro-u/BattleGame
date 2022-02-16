tool
extends Node2D
class_name SpawnPosition

#-------VARIABLES-------#
export(Array, Vector2) var team_pos = [] setget set_team_pos
export(Array, Vector2) var enemy_pos = [] setget set_enemy_pos
 
#loaded node path
var player_team_pos : TeamPosition
var enemy_teamp_pos : TeamPosition

#--------SETGET-------#
func set_team_pos(new_value : Array = team_pos) -> void:
	team_pos = new_value
	player_team_pos.list_position = team_pos

func set_enemy_pos(new_value : Array = enemy_pos) -> void:
	enemy_pos = new_value
	enemy_teamp_pos.list_position = enemy_pos

#--------FUNCTIONS-------#
#init
func _init() -> void:
	if player_team_pos:
		player_team_pos.queue_free()
	player_team_pos = TeamPosition.new()
	add_child(player_team_pos)
	if enemy_teamp_pos:
		enemy_teamp_pos.queue_free()
	enemy_teamp_pos = TeamPosition.new()
	add_child(enemy_teamp_pos)

#ready
func _ready() -> void:
	initialize()

#init
func initialize(list_battlers : Array = []) -> void:
	for battler in list_battlers:
		battler.position = get_children()[battler.team].get_next_pos()
	
