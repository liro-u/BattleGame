tool
extends Node2D
class_name team_position

var current_position = 0

func get_next_pos():
	if get_child_count() > 0:
		var pos = get_child(current_position).position
		current_position = (current_position + 1) % get_child_count()
		return pos
	else:
		return Vector2.ZERO
