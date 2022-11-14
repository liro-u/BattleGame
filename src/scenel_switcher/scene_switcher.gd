extends Node
class_name SceneSwitcher

onready var color_rect = $ColorRect
onready var tween = $tween

export(PackedScene) var first_scene = load("res://src/level_selector/chapitre_1.tscn")

func _init():
	add_to_group("level_switcher")

func _ready():
	color_rect.hide()
	color_rect.modulate.a = 0
	setup_first_scene()

func setup_first_scene():
	var new_first_scene = first_scene.instance()
	add_child(new_first_scene)
	move_child(new_first_scene, 0)
	link_all()

func handle_level_changed(current_scene, data_for_next_scene : Array):
	color_rect.show()
	yield(tween.play(1, 0, 1), "completed")
	change_level(current_scene, data_for_next_scene)
	yield(tween.play(1, 1, 0), "completed")
	color_rect.hide()

func change_level(current_scene, data_for_next_scene):
	var next_scene = null
	var list_func = []
	var list_param = []
	var next_scene_name = data_for_next_scene[0]
	match next_scene_name:
		"level":
			var chapitre = data_for_next_scene[1]
			var level = data_for_next_scene[2]
			var list_team_battler = data_for_next_scene[3]
			var level_data = load("res://asset/level_data/chapitre_" + str(chapitre) + "/level_" + str(level) + "/data.tres")
			if level_data:
				next_scene = load("res://BattleWorld.tscn").instance()
				next_scene.world = level_data.world
				next_scene.team_is_given = (level_data.team_given.size() > 0)
				next_scene.list_player_battler = list_team_battler
				next_scene.list_enemy_battler = level_data.list_enemy_battler
				next_scene.condition_victory_script = level_data.condition_victory_script
				next_scene.data_for_level = data_for_next_scene
				next_scene.xp_gain = level_data.xp_gain
				next_scene.level_name = level_data.level_name
				next_scene.task_list_data = level_data.task.duplicate()
				next_scene.loot_table = level_data.loot_table.duplicate()
			else:
				change_level(current_scene, ["level_selector", chapitre])
		"level_selector":
			var chapitre = data_for_next_scene[1]
			next_scene = load("res://src/GUI/baseMenu/UIManager.tscn").instance()
			list_func.append("open_ui")
			list_param.append(["chapitre_" + str(chapitre)])
		_:
			return
	if next_scene:
		if current_scene:
			current_scene.get_parent().remove_child(current_scene)
			current_scene.queue_free()
		for node in get_tree().get_nodes_in_group("parent_switcher_indicator"):
			node.remove_from_group("parent_switcher_indicator")
		for node in get_tree().get_nodes_in_group("switch_scene_data"):
			node.remove_from_group("switch_scene_data")
		add_child(next_scene)
		for i in range(0, list_func.size()):
			next_scene.call(list_func[i], list_param[i])
		move_child(next_scene, 0)
		link_all()

func link_all():
	for node in get_tree().get_nodes_in_group("parent_switcher_indicator"):
		node.connect("need_changed_scene", self, "change_level")
		node.connect("need_switch_scene", self, "handle_level_changed")

func update_alpha(alpha):
	color_rect.modulate.a = alpha
	
