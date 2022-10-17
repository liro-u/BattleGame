extends TaskBaseScript
class_name TaskMinMaxBat

func _ready():
	add_to_group("min_max_bat_condition")


func check_min_max_bat(battlers):
	var list = battlers.duplicate()
	var nb_bat = 0
	# just count nb battler
	if task_data.element_filter == []:
		nb_bat = battlers.size()
	# count how many battler of the element condition
	else:
		for bat in list:
			if task_data.element_filter.has(bat.stats_reference.element):
				nb_bat += 1
	#au moins X combatant                                         #pas plus de X combatatant
	if (task_data.mini and nb_bat >= task_data.bat_nb) or (not task_data.mini and nb_bat <= task_data.bat_nb):
		task_data.finished = true
		save_task_data()

	
