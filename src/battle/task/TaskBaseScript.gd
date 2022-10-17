extends Node
class_name TaskBaseScript

var task_data

func save_task_data():
	ResourceSaver.save(task_data.resource_path, task_data)
