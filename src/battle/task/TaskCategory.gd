extends Node
class_name TaskCategory

var task_category_data
var path_list_task
var tree

func _init(dat, t):
	tree = t
	task_category_data = dat
	path_list_task = task_category_data.resource_path.replace(Global.dataFolderPreset + "://player_data", "res://asset").replace(".tres", "/")
	check_task_update(OS.get_unix_time())
	if get_child_count() == 0:
		load_task()
	
func load_task():
	for dat_task in task_category_data.task_list:
		var new_task
		if "type_name" in dat_task:
			match dat_task.type_name:
				"ElementCondition":
					new_task = TaskElementCondition.new()
				"MinMaxBat":
					new_task = TaskMinMaxBat.new()
				"MinMaxTurn":
					new_task = TaskMinMaxTurn.new()
				"RequiredBattler":
					new_task = TaskRequiredBat.new()
			new_task.task_data = dat_task
			add_child(new_task)

func check_task_update(current_timestamp):
	if task_category_data.duration_before_refresh > 0 && current_timestamp > task_category_data.next_update_timestamp:
		refresh_task(current_timestamp)
		tree.call_group_flags(2, "task_ui", "load_task")

func refresh_task(current_timestamp):
	task_category_data.next_update_timestamp = current_timestamp + task_category_data.duration_before_refresh
	
	var nb_task = task_category_data.task_list.size()
	task_category_data.task_list = []
	
	var list_task_name = SaverInventory.get_all_file(path_list_task)
	if (list_task_name.size() > 0):
		for child in get_children():
			child.queue_free()
			
		for i in range(0, nb_task):
			var new_task = get_random_task(list_task_name)
			task_category_data.task_list.append(new_task)
		load_task()
		ResourceSaver.save(task_category_data.resource_path, task_category_data)

func get_random_task(list_task_name):
	return load(path_list_task + list_task_name[randi() % list_task_name.size()]).duplicate(true)
	
	
	
