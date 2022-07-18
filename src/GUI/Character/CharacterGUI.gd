tool
extends Control

onready var name_label = $Stats/Text/Name
onready var level_label = $Stats/Text/Level
onready var health_bar = $Stats/health
onready var mana_bar = $Stats/mana
onready var modifier_indicator = $Stats/modifier_indicator

var is_init = false

func initialize(battler) -> void:
	update_stats(battler)
	if ! is_init:
		is_init = true
		battler.stats.connect("shield_created", self, "shield_created")
		battler.stats.connect("health_changed", health_bar, "update_first_value")
		battler.stats.connect("shield_changed", health_bar, "update_value")
		battler.stats.connect("mana_changed", mana_bar, "update_value")

func update_stats(battler) -> void:
	name_label.text = battler.startingStats.name_char
	level_label.text = "Niv" + str(battler.stats.level)
	health_bar.initialize(battler.stats.max_health)
	mana_bar.initialize(battler.stats.max_mana)

func shield_created(new_shield : float) -> void:
	if health_bar.list_bar.size() > 1:
		health_bar.delete_bar()
	health_bar.add_bar(new_shield)
	health_bar.set_value(1)
	health_bar.update_value(new_shield)
