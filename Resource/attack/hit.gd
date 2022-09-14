extends Resource
class_name start_hit

export var attack_name : String
export(String, MULTILINE) var attack_description
export var icon : Texture
export var mana_cost : int
export var element : int = Element.Element.AIR
export var turn_needed : int
export var actual_turn : int

export var team_target_ennemy : bool = true
export var modifiers_for_team : Array
export var modifiers_for_enemy : Array
