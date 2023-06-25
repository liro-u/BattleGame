extends TaskBaseScript
class_name TaskRequiredBat

func ready_herit():
	add_to_group("required_bat")

func check_required_bat(battlers):
	var condition_list = task_data.required_bat_list.duplicate()
	for battler in battlers:
		if condition_list.has(battler.stats_reference):
			#OU
			if task_data.ou:
				finish_task()
				break
			#ET
			else:
				condition_list.erase(battler.stats_reference)
	if (not task_data.ou) and (condition_list.size() == 0):
		finish_task()
