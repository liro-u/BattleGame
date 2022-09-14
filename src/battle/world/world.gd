tool
extends Node2D
class_name BattleWorld

#------VARIABLES---------#
export var world : Resource
export(Array, Resource) var list_player_battler
export(Array, Resource) var list_enemy_battler
export(Resource) var condition_victory_script
export var data_for_level = ["level", 1, 1]
export var level_name = "name of level"
export var xp_gain = 0
#loaded node path
onready var battleGUI = $battleGUI
var turn_queue : TurnQueue
var spawn_position : SpawnPosition
var back_ui_cancel : Area2D
var condition_victory : Node

export(PackedScene) var battler_scene

#---------FUNCTIONS-----#
#init
func _init() -> void:
	if condition_victory:
		condition_victory.queue_free()
	condition_victory = Node.new()
	condition_victory.add_to_group("condition_victory")
	add_child(condition_victory)
	if back_ui_cancel:
		back_ui_cancel.queue_free()
	back_ui_cancel = ClickableArea.new()
	back_ui_cancel.priority = 0
	var rec = RectangleShape2D.new()
	rec.extents = Vector2(512, 300)
	back_ui_cancel.collision_shape = rec
	back_ui_cancel.collision_position = Vector2(512, 300)
	back_ui_cancel.add_to_group("ui_cancel")
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
	randomize()
	condition_victory.set_script(condition_victory_script)
	var main_menu_switcher = SwitchSceneData.new()
	var next_level_switcher = SwitchSceneData.new("is_clicked")
	var restart_level_switcher = SwitchSceneData.new("is_clicked")
	match data_for_level[0]:
		"level":
			main_menu_switcher.next_scene_data = ["level_selector", data_for_level[1]]
			var list_dup = []
			for battler_data in list_player_battler:
				if !battler_data.is_given:
					list_dup.append(battler_data)
			if list_dup.size() > 0:
				next_level_switcher.next_scene_data = ["level", data_for_level[1], data_for_level[2] + 1, list_dup]
			else:
				next_level_switcher.next_scene_data = ["level_selector", data_for_level[1]]
			restart_level_switcher.next_scene_data = data_for_level
	get_tree().call_group_flags(2, "button_main_menu", "add_child", main_menu_switcher)
	get_tree().call_group_flags(2, "button_next_level", "add_child", next_level_switcher)
	get_tree().call_group_flags(2, "button_restart", "add_child", restart_level_switcher)
	initialize()

#init
func initialize() -> void:
	get_tree().get_nodes_in_group("level_name_label")[0].text = level_name
	add_child(world.aspect.instance())
	spawn_position.team_pos = world.team_pos
	spawn_position.enemy_pos = world.enemy_pos
	
	add_battler(list_enemy_battler, 1)
	add_battler(list_player_battler)
	
	spawn_position.initialize(turn_queue.get_children())
	turn_queue.initialize()
	battleGUI.initialize(turn_queue)
