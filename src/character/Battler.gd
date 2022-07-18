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
onready var modifier : Node = $modifier_list
onready var turn_indicator : Position2D = $Viewport/texture/turn_indicator
onready var textureNode : Node2D = $Viewport/texture
onready var sprite : Sprite = $Sprite
onready var tween_mix_value : Tween = $TweenMixValue
onready var critical_indicator : Particles2D = $CriticalHit

var clickable_area : ClickableArea
var mesh2D : GDDragonBones
var stats : BattlerStats
export var max_mix_value : float = 0.8
export var time_to_shade : float = 0.5

var list_indicator_char_turn = []
export var auto_wait_time = Vector2(0.1, 0.4)
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
	add_to_group("team" + str(team))

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
		stats.connect("health_depleted", self, "add_to_group", ["remove_battler_from_world"])


func remove_from_world():
	var turn_queue = get_tree().get_nodes_in_group("turn_queue")[0]
	get_parent().remove_child(self)
	var active_battler_index = turn_queue.active_battler_index
	var max_nb_case = turn_queue.get_parent().battleGUI.turnline.max_nbr_case
	var nb_battler = turn_queue.get_child_count()
	for elem in list_indicator_char_turn.duplicate():
		turn_queue.get_parent().battleGUI.turnline.del_this_case(elem)
		var next_battler_index = (active_battler_index + max_nb_case - list_indicator_char_turn.size() - 1) % nb_battler
		var next_battler_to_add = turn_queue.get_child(next_battler_index)
		turn_queue.get_parent().battleGUI.turnline.add_case(next_battler_to_add)
	queue_free()

func timed_update_stats():
	if attack:
		attack.initialize(startingStats.attack_list)
	if character_gui:
		character_gui.update_stats(self)
		character_gui.initialize(self)

func play_auto():
	yield(get_tree().create_timer(2), "timeout")
	modifier.apply()
	var active_battler = get_tree().get_nodes_in_group("turn_queue")[0].active_battler
	var possible_atck = []
	yield(get_tree().create_timer(rand_range(auto_wait_time.x, auto_wait_time.y)), "timeout")
	for atck in attack.active_attack:
		if atck.actual_turn <= 0 and atck.mana_cost <= active_battler.stats.mana:
			possible_atck.append(atck)
	if possible_atck.size() > 0:
		var active_attack = possible_atck[randi() % possible_atck.size()]
		active_attack.ask_use_attack(true)
		for node in get_tree().get_nodes_in_group("charact"):
			if ((node.team == active_battler.team) and active_attack.target_enemy) or ((node.team != active_battler.team) and not active_attack.target_enemy):
				node.shade()
			else:
				node.clickable_area.add_to_group("active_clickable_area")
		yield(get_tree().create_timer(rand_range(auto_wait_time.x, auto_wait_time.y)), "timeout")
		var list_clickable_area = get_tree().get_nodes_in_group("active_clickable_area")
		if list_clickable_area.size() > 0:
			list_clickable_area[randi() % list_clickable_area.size()].emit_signal("pressed")
		else:
			recharge_mana(true)
	else:
		recharge_mana(true)
	

func ask_action_turn() -> void:
	get_tree().call_group("action_gui", "setup_with_charact", self)
	yield(get_tree().create_timer(2), "timeout")
	modifier.apply()
	modifier.verif_delete()

func end_turn() -> void:
	attack.update_turn()

func area_is_clicked():
	var last_target_a = get_tree().get_nodes_in_group('target_battler')
	if last_target_a.size() == 1:
		last_target_a[0].remove_from_group('target_battler')
	add_to_group('target_battler')
	get_tree().call_group_flags(2, "active_attack", "use_attack")

func shade() -> void:
	tween_mix_value.play(time_to_shade, sprite.material.get("shader_param/mix_amount"), 0.8)

func unshade() -> void:
	tween_mix_value.play(time_to_shade, sprite.material.get("shader_param/mix_amount"), 0.0)

func set_mix_amount(sat):
	sprite.material.set("shader_param/mix_amount", sat)
	
func add_modifier(mod):
	var new_mod = modifier_apply.new(mod)
	modifier.add_child(new_mod)

func apply_mod(mod):
	#manage attack
	if mod.health < 0:
		if mod.with_crit:
			critical_indicator.emitting = true
		stats.health_changed(mod.health + (sqrt(pow(mod.health, 2) + pow(stats.defense, 2))) / 5)
		stats.mana_changed(mod.mana)
	else:
		stats.health_changed(mod.health)
		
func recharge_mana(skip_set_gui = false):
	stats.mana_changed(80)
	if !skip_set_gui:
		get_tree().call_group_flags(2, "action_state", "set_gui", "end_turn")
	else:
		get_tree().call_group_flags(2, "action_state", "set_gui", "end_turn")

