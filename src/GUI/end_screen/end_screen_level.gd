extends VBoxContainer

onready var anim_player = $"AnimationPlayer"
onready var xp_bar = $XPBar
onready var label = $Control/Label
onready var anim_player_label = $Control/Label/AnimationPlayer
onready var particle2D = $Control/Particles2D
onready var texture = $TextureRect
onready var level_label = $"XPBar/level_label"

export var battler_data : Resource
export var final_battler_data : Resource

var xp
var level
var starting_xp
var level_palier

var final_xp 
var final_level 

var max_xp_for_level

func initialize(bat = battler_data, f_bat = final_battler_data):
	battler_data = bat
	final_battler_data = f_bat
	xp = battler_data.xp
	level = battler_data.level
	starting_xp = battler_data.stats_reference.starting_xp_needed
	level_palier = battler_data.stats_reference.level_palier

	level_label.text = "LVL " + str(level)
	final_xp = final_battler_data.xp
	final_level = final_battler_data.level
	#init for actual level and xp
	max_xp_for_level = levelCalculation.xp_needed_for_level(level, starting_xp, level_palier)
	xp_bar.set_value(xp / max_xp_for_level * 100)
	
	texture.texture = battler_data.stats_reference.hight_icon

func set_anim(anim_name = "appear"):
	anim_player.current_animation = anim_name


func anim_ended(anim_name):
	match anim_name:
		"appear":
			if !battler_data.is_given:
				update_xp_level()
		"disappear":
			queue_free()

func update_xp_level():
	while level != final_level or xp != final_xp:
		if level != final_level:
			#update xp value at max value
			max_xp_for_level = levelCalculation.xp_needed_for_level(level, starting_xp, level_palier)
			xp_bar.update_value(100)
			yield(xp_bar.value_tween, "tween_all_completed")
			particle2D.restart()
			particle2D.emitting = true
			label.text = "Level Up !"
			anim_player_label.current_animation = "level_up"
			#init bar with next level xp needed
			level += 1
			max_xp_for_level = levelCalculation.xp_needed_for_level(level, starting_xp, level_palier)
			xp = 0
			xp_bar.set_value(xp / max_xp_for_level * 100)
			level_label.text = "LVL " + str(level)
		if level == final_level and xp != final_xp:
			#update xp at good value
			xp = final_xp
			xp_bar.update_value(final_xp / max_xp_for_level * 100)
			yield(xp_bar.value_tween, "tween_all_completed")
			label.text = "+" + str(final_xp) + " EXP."
			anim_player_label.current_animation = "level_up"
			yield(anim_player_label, "animation_finished")
		
