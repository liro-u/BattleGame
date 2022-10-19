extends VBoxContainer

onready var stats_calculation = $"../StatsWithLevel"
onready var hp = $"HP/Value"
onready var mana = $"MANA/Value"
onready var atk = $"ATK/Value"
onready var vit = $"VIT/Value"
onready var def = $"DEF/Value"
onready var crit_rate = $"CRIT_RATE/Value"
onready var crit_damage = $"CRIT_DAMAGE/Value"

func update_info(data):
	stats_calculation.initialize(data, data.stats_reference)
	stats_calculation.update_stats()
	
	hp.text = str(int(stats_calculation.max_health))
	mana.text = str(int(stats_calculation.max_mana))
	atk.text = str(int(stats_calculation.strength))
	vit.text = str(int(stats_calculation.speed))
	def.text = str(int(stats_calculation.defense))
	crit_rate.text = str(int(stats_calculation.crit)) + "%"
	crit_damage.text = str(stepify(stats_calculation.crit_mult, 0.01) * 100) + "%"
