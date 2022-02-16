tool
extends StatsWithLevel
class_name BattlerStats

#--------------VARIABLES--------------#
#changing variable
var shield : float = 0.0
var health : float = 0.0
var mana : float = 0.0

#----------------SIGNAL--------------#
#health
signal health_changed(new_health)
signal health_depleted()
#mana
signal mana_changed(new_mana)
#shield
signal shield_created(new_shield)
signal shield_changed(new_value)

#-----------FUNCTION------------#
#ready
func _ready() -> void:
	initialize()

#initialize node
func initialize(selected_ownerStats : OwnerStats = null, selected_startingStats : StartingStats = null) -> void:
	set("startingStats", selected_startingStats)
	set("ownerStats", selected_ownerStats)
	health = max_health
	mana = max_mana

#print just changing stats
func print_changing_stats() -> void:
	print()
	print("mana : ", mana)
	print("health : ", health)
	print("shield : ", shield)

#create new shield
func create_shield(value : float) -> void:
	if shield == 0:
		shield = value
		emit_signal("shield_created", value)

#change health
func health_changed(additional_health : float) -> void:
	#adding health
	if additional_health > 0:
		health += additional_health
		health = clamp(health, 0, max_health)
		emit_signal("health_changed", health)
	#substract health
	else:
		#substract from shield
		if shield > 0.0:
			#shield will be > 0 after substract
			if shield > -additional_health:
				shield += additional_health
				additional_health = 0
				emit_signal("shield_changed", shield)
			#shield will not exist after substract
			else:
				additional_health += shield
				shield = 0
				emit_signal("shield_changed", additional_health)
			#manage rest life after shield substract
			health += additional_health
			health = clamp(health, 0, max_health)
		#substract from health
		else:
			health += additional_health
			health = clamp(health, 0, max_health)
			emit_signal("health_changed", health)
	if health == 0:
		emit_signal("health_depleted")

#change mana
func mana_changed(additional_mana : float) -> void:
	mana += additional_mana
	clamp(mana, 0, max_mana)
	emit_signal("mana_changed", mana)
