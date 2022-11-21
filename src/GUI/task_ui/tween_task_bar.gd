extends MarginContainer

onready var star_list = $MarginContainer2/StarList
onready var progressBar = $MarginContainer/TextureProgress

export var nb_task = 10
export var task_finished = 5

func _ready():
	initialize()
	
func initialize():
	progressBar.initialize(nb_task)
	progressBar.set_value(task_finished)
	star_list.initialize(nb_task, task_finished)
	yield(get_tree().create_timer(1), "timeout")
	progressBar.tween_to_value(task_finished + 3)

func _on_CurveTween_curve_tween(sat):
	if star_list.next_star and sat >= star_list.next_star.nb_star:
		star_list.validate_next_star()
