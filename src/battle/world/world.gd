tool
extends Node
class_name BattleWorld

onready var turn_queue = $TurnQueue
onready var spawn_position = $spawn_position

func _ready():
	randomize()
	initialize()
	
func initialize():
	spawn_position.initialize(turn_queue.get_children())
	turn_queue.initialize()
