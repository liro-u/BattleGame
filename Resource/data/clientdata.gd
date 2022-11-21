extends Resource
class_name ClientData
 
export var max_level : int = 100
export var level : int = 1
export var xp : float

export(int) var starting_xp_needed
export(Dictionary) var level_palier = {0: 0}

export(int) var last_stamina_claim = -1
export(int) var duration_gain_stamina = 60
