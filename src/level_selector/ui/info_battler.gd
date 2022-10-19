extends VBoxContainer

onready var stats_calculation = $"../StatsWithLevel"
onready var name_label = $Name
onready var level_label = $Level
onready var hp = $"HP/value"
onready var mana = $"MANA/value"
onready var atk = $"ATK/value"
onready var vit = $"VIT/value"
onready var def = $"DEF/value"
onready var crit_rate = $"CritRate/value"
onready var crit_damage = $"CritDamage/value"
onready var attack_list = $"ScrollContainer/VBoxContainer"

func update_info(data):
	name_label.text = str(data.stats_reference.name_char)
	level_label.text = "Level " + str(data.level)
	
	stats_calculation.initialize(data, data.stats_reference)
	stats_calculation.update_stats()
	
	hp.text = str(int(stats_calculation.max_health))
	mana.text = str(int(stats_calculation.max_mana))
	atk.text = str(int(stats_calculation.strength))
	vit.text = str(int(stats_calculation.speed))
	def.text = str(int(stats_calculation.defense))
	crit_rate.text = str(int(stats_calculation.crit)) + "%"
	crit_damage.text = str(stepify(stats_calculation.crit_mult, 0.01) * 100) + "%"

	
	attack_list.update_info(data.stats_reference.attack_list)
