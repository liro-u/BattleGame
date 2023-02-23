extends Particles2D

func update_resize():
	var parent_size = (get_parent().rect_size / 2) 
	position = parent_size
	parent_size += Vector2(12, 12)
	var new_size = Vector3(parent_size.x, parent_size.y, 0)
	process_material.emission_box_extents = new_size
