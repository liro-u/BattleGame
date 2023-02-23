extends VBoxContainer

var task_resume_instance = load("res://src/GUI/task_ui/TaskRecap.tscn")

class CustomSorter:
	func filter_by_claimed(a, b):
		if a.claimed:
			return false
		return true
	
	func filter_by_finished(a, b):
		if a.finished:
			return false
		return true
		
func initialize(task_list, node):
	for child in get_children():
		if child is TextureRect:
			child.queue_free()
	
	task_list.sort_custom(CustomSorter.new(), "filter_by_finished")
	task_list.sort_custom(CustomSorter.new(), "filter_by_claimed")
	for task_data in task_list:
		var new_task_resume = task_resume_instance.instance()
		add_child(new_task_resume)
		new_task_resume.initialize(task_data)
		new_task_resume.connect("save_task", node, "save_task")
	rect_min_size.x = get_parent().rect_size.x
	get_parent().initialize()


func _on_ScrollContainer2_resized():
	rect_min_size.x = get_parent().rect_size.x
	get_parent().initialize()
