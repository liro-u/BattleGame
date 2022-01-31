tool
extends Node
class_name BattlerStats

signal health_changed(new_health)
signal health_depleted()

signal mana_changed(new_mana)

var name_char : String
var rarity : String
var skin_path : String

var level : int

var health : float
var mana : float
var max_health : float
var max_mana : float
var strength : float
var defense : float
var speed : float
var crit : float

var team : int
var attack_list : Array

func initialize(stats, ownerStats):
	var stats_calculator = RealStatsCalculator.new()
	stats_calculator.ownerStats = ownerStats
	stats_calculator.startingStats = stats
	stats_calculator.start_calcul()
	
	name_char = stats_calculator.name_char
	rarity = stats_calculator.rarity
	skin_path = stats_calculator.skin_path
	
	level = stats_calculator.level
	
	max_health = stats_calculator.max_health
	max_mana = stats_calculator.max_mana
	strength = stats_calculator.strength
	defense = stats_calculator.defense
	speed = stats_calculator.speed
	crit = stats_calculator.crit
	
	team = get_parent().team
	attack_list = stats_calculator.attack_list
	
	health = max_health
	mana = max_mana
	
	#print_stats()

func print_stats():
	print()
	print("name_char : ", name_char)
	print("rarity : ", rarity)
	print("level : ", level)
	print("max_health : ", max_health)
	print("max_mana : ", max_mana)
	print("strength : ", strength)
	print("defense : ", defense)
	print("speed : ", speed)
	print("crit : ", crit)

func print_changing_stats():
	print()
	print("mana : ", mana)
	print("health : ", health)
	
func take_damage(hit):
	var for_team_mult = 1
	if hit.for_team:
		for_team_mult = -1
	health -= hit.damage * for_team_mult * 20
	health = clamp(health, 0, max_health)
	emit_signal("health_changed", health)
	if health == 0:
		yield(get_parent().play_anim("die"), "completed")
		emit_signal("health_depleted")
		get_parent().hide()
	elif for_team_mult:
		get_parent().play_anim("takeDamage")

func change_mana(mana_cost):
	mana -= mana_cost
	mana = clamp(mana, 0, max_mana)
	emit_signal("mana_changed", mana)
