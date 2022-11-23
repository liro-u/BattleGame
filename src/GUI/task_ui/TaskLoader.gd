extends VBoxContainer

var task_resume_instance = load("res://src/GUI/task_ui/TaskRecap.tscn")

func initialize(task_list):
	for child in get_children():
		if child is TextureRect:
			child.queue_free()
	
	for task_data in task_list:
		var new_task_resume = task_resume_instance.instance()
		add_child(new_task_resume)
		new_task_resume.initialize(task_data)
