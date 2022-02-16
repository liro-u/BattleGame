tool
extends Node
class_name StatsWithLevel

#------------VARIABLES----------#
#init
export var startingStats : Resource = null setget set_startingStats
export var ownerStats : Resource = null setget set_ownerStats
#information
var level : int
#stats
var max_health : float
var max_mana : float
var strength : float
var defense : float
var speed : float
var crit : float

#----------SIGNAL-----------#
signal stats_updated()

#----------SETGET----------#
#Owner Stats
func set_ownerStats(new_value : Resource) -> void:
	ownerStats = new_value
	update_stats()

#Starting Stats
func set_startingStats(new_value : Resource) -> void:
	startingStats = new_value
	update_stats()

#---------FUNCTION---------#
#ready
func _ready() -> void:
	initialize()

#initialize node
func initialize(selected_ownerStats : OwnerStats = null, selected_startingStats : StartingStats = null) -> void:
	set("startingStats", selected_startingStats)
	set("ownerStats", selected_ownerStats)

#start calcul
func update_stats(selected_ownerStats = ownerStats, selected_startingStats = startingStats) -> void:
	if selected_ownerStats and selected_startingStats:
		#level
		level = selected_ownerStats.level
		#stats
		max_health = calcul_stat_by_level(selected_startingStats.max_health, selected_startingStats.health_gain)
		max_mana = calcul_stat_by_level(selected_startingStats.max_mana, selected_startingStats.mana_gain)
		strength = calcul_stat_by_level(selected_startingStats.strength, selected_startingStats.strength_gain)
		defense = calcul_stat_by_level(selected_startingStats.defense, selected_startingStats.defense_gain)
		speed = calcul_stat_by_level(selected_startingStats.speed, selected_startingStats.speed_gain)
		crit = calcul_stat_by_level(selected_startingStats.crit, selected_startingStats.crit_gain)
		#emit signal
		emit_signal("stats_updated")

#calcul stats by level
func calcul_stat_by_level(starting_stat : float, gain : float, selected_level = level) -> float:
	starting_stat += (selected_level - 1) * gain
	return starting_stat

#print all stats
func print_stats() -> void:
	print()
	print("level : ", level)
	print("max_health : ", max_health)
	print("max_mana : ", max_mana)
	print("strength : ", strength)
	print("defense : ", defense)
	print("speed : ", speed)
	print("crit : ", crit)
