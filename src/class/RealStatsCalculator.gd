extends Node
class_name RealStatsCalculator

export var startingStats : Resource
export var ownerStats : Resource

var name_char : String
var rarity : String
var skin_path : String

var level : int
var xp : int

var health_gain : float
var mana_gain : float
var strength_gain : float
var defense_gain : float
var speed_gain : float
var crit_gain : float

var health : float
var mana : float
var max_health : float
var max_mana : float
var strength : float
var defense : float
var speed : float
var crit : float

var attack_list : Array

func start_calcul():
	name_char = startingStats.name_char
	rarity = startingStats.rarity
	skin_path = startingStats.skin_path

	level = ownerStats.level
	xp = ownerStats.xp
	
	health_gain = startingStats.health_gain
	strength_gain = startingStats.strength_gain
	defense_gain = startingStats.defense_gain
	speed_gain = startingStats.speed_gain
	crit_gain = startingStats.crit_gain
	mana_gain = startingStats.mana_gain
	
	max_health = calcul_stat_by_level(startingStats.max_health, health_gain)
	max_mana = calcul_stat_by_level(startingStats.max_mana, mana_gain)
	health = max_health
	mana = max_mana
	strength = calcul_stat_by_level(startingStats.strength, strength_gain)
	defense = calcul_stat_by_level(startingStats.defense, defense_gain)
	speed = calcul_stat_by_level(startingStats.speed, speed_gain)
	crit = calcul_stat_by_level(startingStats.crit, crit_gain)
	
	attack_list = startingStats.attack_list
	
func calcul_stat_by_level(starting_stat, gain):
	starting_stat += (level - 1) * gain
	return starting_stat
