extends Resource
class_name LevelData

export var unlocked = false
export var level_name : String
export var world : Resource
export(Array, Resource) var team_given
export(Array, Resource) var battler_given
export var xp_gain : float = 150
export var list_player_battler : Array
export var list_enemy_battler : Array
export var condition_victory_script : Resource
export(Array, Resource) var task = [null,null,null]
export(Array, Resource) var loot_table
export(int) var stamina_cost
