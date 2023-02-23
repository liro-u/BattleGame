extends TaskBaseScript
class_name TaskElementCondition

func ready_herit():
	add_to_group("element_condition")
	
func check_element_condition(battlers):
	var list_bat = battlers.duplicate()
	var element_condition = task_data.element_list.duplicate()
	var list_element = []
	for battler in battlers:
		var elem = battler.stats_reference.element
		if task_data.au_moins:
			if task_data.besoin:
				if task_data.ou:
					if element_condition.has(elem):
						finish_task()
				else:
					if element_condition.has(elem):
						element_condition.erase(elem)
			else:
				if not element_condition.has(elem):
					finish_task()
		else:
			if task_data.besoin:
				if element_condition.has(elem):
					list_bat.erase(battler)
			else:
				if element_condition.has(elem):
					if not list_element.has(elem):
						list_element.append(elem)
	
	if task_data.au_moins:
		if task_data.besoin:
			if not task_data.ou:
				if element_condition.size() == 0:
					finish_task()
	else:
		if task_data.besoin:
			if list_bat.size() == 0:
				finish_task()
		else:
			if task_data.ou:
				if list_element.size() == 0:
					finish_task()
			else:
				if list_element.size() < element_condition.size():
					finish_task()
