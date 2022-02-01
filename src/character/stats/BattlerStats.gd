tool
extends "res://src/character/stats/StatsWithLevel.gd"
class_name BattlerStats

#--------------VARIABLES--------------#
#changing variable
var health : float = 0.0
var mana : float = 0.0

#----------------SIGNAL--------------#
#health
signal health_changed(new_health)
signal health_depleted()
#mana
signal mana_changed(new_mana)

#-----------FUNCTION------------#
#ready
func _ready() -> void:
	initialize()

#initialize node
func initialize(selected_ownerStats = null, selected_startingStats = null) -> void:
	set("startingStats", selected_startingStats)
	set("ownerStats", selected_ownerStats)
	health = max_health
	mana = max_mana
	print_changing_stats()

#print just changing stats
func print_changing_stats() -> void:
	print()
	print("mana : ", mana)
	print("health : ", health)
