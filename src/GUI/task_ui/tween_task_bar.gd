extends MarginContainer

onready var star_list = $MarginContainer2/StarList
onready var progressBar = $MarginContainer/TextureProgress

export var nb_task = 10
export var task_finished = 5
export var wait_before_update_bar = 0.2

func _ready():
	initialize()
	
func initialize(t = task_finished, n = nb_task):
	task_finished = t
	nb_task = n
	if (nb_task > 0):
		show()
		progressBar.initialize(nb_task)
		progressBar.set_value(0)
		star_list.initialize(nb_task, 0)
		progressBar.stop_all()
		yield(get_tree().create_timer(wait_before_update_bar), "timeout")
		progressBar.tween_to_value(task_finished)
	else:
		hide()

func tween_to_value(t):
	task_finished = t
	progressBar.tween_to_value(task_finished)
	
func _on_CurveTween_curve_tween(sat):
	if star_list.next_star and sat >= star_list.next_star.nb_star:
		star_list.validate_next_star()
