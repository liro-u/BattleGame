extends Node
class_name modifierList

func apply() -> void:
	for mod in get_children():
		mod.apply()

func verif_delete() -> void:
	for mod in get_children():
		mod.verif_delete()
