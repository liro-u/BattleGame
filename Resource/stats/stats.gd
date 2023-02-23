extends Resource
class_name StartingStats

export(String) var name_char = "Default"
export(Resource) var information_battler
export(int) var element = Element.Element.NONE
export(int) var type = Type.Type.NONE
export(GDDragonBonesResource) var ske
export(Texture) var icon
export(Texture) var hight_icon
export(Texture) var splash_art
export(Shape2D) var collision
export(Vector2) var collision_position
export(int) var starting_xp_needed
export(Dictionary) var level_palier = {0: 0}

export var health_gain : float
export var mana_gain : float
export var strength_gain : float
export var defense_gain : float 
export var speed_gain : float
export var crit_gain : float
export var crit_mult_gain : float
export var magie_gain : float

export var max_health : float
export var max_mana : float
export var strength : float
export var defense : float
export var speed : float
export var crit : float
export var crit_mult : float = 1
export var magie : float

export(Array, Resource) var attack_list
