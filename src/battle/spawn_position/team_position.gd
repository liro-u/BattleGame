tool
extends Node2D
class_name TeamPosition

#-------VARIABLES----------#
export(Array, Vector2) var list_position = [] setget set_list_position
var current_position = list_position.size() - 1

#---------SETGET-----#
func set_list_position(new_value : Array = list_position) -> void:
	list_position = new_value
	current_position = list_position.size() - 1

#---------FUNCTIONS---------#
func get_next_pos() -> Vector2:
	if list_position.size() > 0:
		current_position = (current_position + 1) % list_position.size()
		return list_position[current_position]
	else:
		return Vector2.ZERO

func get_pos() -> Vector2:
	if list_position.size() > 0:
		return list_position[current_position]
	else:
		return Vector2.ZERO
