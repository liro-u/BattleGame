extends Resource
class_name StartingStats

export var name_char = "Default"
export var rarity = "Common"
export var skin_path = "res://asset/chararacters/001_testChar/Mesh.tscn"

export var health_gain : float
export var mana_gain : float
export var strength_gain : float
export var defense_gain : float 
export var speed_gain : float
export var crit_gain : float

export var max_health : float
export var max_mana : float
export var strength : float
export var defense : float
export var speed : float
export var crit : float

export(Array, Resource) var attack_list
