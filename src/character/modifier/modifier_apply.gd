extends Node
class_name modifier_apply
var utilisation_restante : int = -1
var modifier
var mod_indicator = null

func _init(mod):
	utilisation_restante = mod.turn
	modifier = mod

func _ready():
	if modifier.shield > 0:
		get_parent().get_parent().stats.create_shield(modifier.shield)
	get_parent().get_parent().stats.combine(self)
	if utilisation_restante != 1 and utilisation_restante != 0 and modifier.texture != "":
		var new_mod_indicator = load("res://src/GUI/Character/mod_indicator.tscn").instance()
		new_mod_indicator.texture = load(modifier.texture)
		new_mod_indicator.turn = utilisation_restante - 1
		get_parent().get_parent().character_gui.modifier_indicator.add_child(new_mod_indicator)
		mod_indicator = new_mod_indicator
		yield(mod_indicator, "ready")
	apply()

func apply():
	if utilisation_restante != 0:
		utilisation_restante -= 1
		get_parent().get_parent().apply_mod(modifier)
	if mod_indicator:
		mod_indicator.update_turn(utilisation_restante - 1)
		if utilisation_restante == 1:
			mod_indicator.hide()
			
func verif_delete():
	if utilisation_restante == 0:
		if mod_indicator:
			mod_indicator.queue_free()
		get_parent().get_parent().stats.uncombine(modifier)
		queue_free()
