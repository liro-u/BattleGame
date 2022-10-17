extends TaskBaseScript
class_name TaskMinMaxTurn

var turn = 0

func _ready():
	add_to_group("min_max_turn")

func add_one_turn():
	if not task_data.finished:
		turn += 1
		if task_data.mini and task_data.NBTurn <= turn or not task_data.mini and task_data.NBTurn >= turn:
			task_data.finished = true
			save_task_data()

func check_min_max_turn():
	#au moins X tour                                         #pas plus de X tour
	if (task_data.mini and turn >= task_data.NBTurn) or (not task_data.mini and turn <= task_data.NBTurn):
		task_data.finished = true
		save_task_data()

