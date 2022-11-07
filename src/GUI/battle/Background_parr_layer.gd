tool
extends Node2D
export(float) var repeat_size = 1200
var aspect_instance = null
var nb_gen = 0

func initialize(aspect):
	aspect_instance = aspect
	nb_gen = 0
	update_size(get_viewport_rect().size)
		
func update_size(size):
	while size.x >= repeat_size * nb_gen:
		var new_node_back = aspect_instance.instance()
		var new_node_front = aspect_instance.instance()
		new_node_back.position.x = -repeat_size * nb_gen
		new_node_front.position.x = repeat_size * nb_gen
		add_child(new_node_back)
		add_child(new_node_front)
		nb_gen += 1
