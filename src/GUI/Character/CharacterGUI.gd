tool
extends Control

onready var name_label = $Stats/Text/Name
onready var level_label = $Stats/Text/Level
onready var health_bar = $Stats/health
onready var mana_bar = $Stats/mana

func initialize(stats):
	health_bar.initialize(stats.max_health)
	mana_bar.initialize(stats.max_mana)
	name_label.text = stats.name_char
	level_label.text = "Niv" + str(stats.level)
