extends Resource
class_name StartingStats

export(String) var name_char = "Default"
export(String) var rarity = "Common"
export(GDDragonBonesResource) var ske
export(Texture) var icon
export(Texture) var large_icon
export(int) var X_size_large_icon = 150
export(Shape2D) var collision
export(Vector2) var collision_position

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
