extends Node
class_name TaskBaseScript

var task_data

func _ready():
	add_to_group("task")
	ready_herit()

func ready_herit():
	pass
	
func save_task_data():
	ResourceSaver.save(task_data.resource_path, task_data)

func finish_task():
	task_data.finished = true
	SaverInventory.addNewThings(task_data.reward)
	save_task_data()
