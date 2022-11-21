extends HBoxContainer

export(PackedScene) var stars_instance
export var nb_task_between_reward = 2
	
var next_star = null

func initialize(n, star_finished):
	# delete all child
	for child in get_children():
		child.queue_free()
	
	# make first star invisible
	var new_star = stars_instance.instance()
	add_child(new_star)
	new_star.modulate.a = 0
	
	#create all stars
	for i in range(0, n / nb_task_between_reward):
		var new_space = VSeparator.new()
		new_space.size_flags_horizontal = SIZE_EXPAND_FILL
		new_space.self_modulate.a = 0
		add_child(new_space)
		new_star = stars_instance.instance()
		add_child(new_star)
		new_star.initialize((i + 1) * nb_task_between_reward)
		if i < (star_finished / nb_task_between_reward):
			new_star.validate_task()
		elif i < ((star_finished / nb_task_between_reward) + 1):
			next_star = new_star
			
func validate_next_star():
	if next_star:
		next_star.validate_task()
		if next_star.get_index() + 2 < .get_children().size():
			next_star = .get_children()[next_star.get_index() + 2]
	
	

