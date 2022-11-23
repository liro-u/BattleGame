extends VBoxContainer

var task_path = "res://player_data/task/"
var button_instance = load("res://src/GUI/task_ui/TaskTab.tscn")

var button_list = []
var last_button

signal load_task

func _ready():
	button_list = get_children()
	initialize()
	
func initialize():
	for child in button_list:
		child.queue_free()
	button_list = []
		
	var task_folders = SaverInventory.get_all_file(task_path)
	for task_folder in task_folders:
		var task_data = load(task_path + task_folder)
		
		var new_button = button_instance.instance()
		new_button.text = task_data.task_list_name
		button_list.append(new_button)
		new_button.task_list = task_data.task_list
		
		add_child(new_button)
		new_button.connect("pressed", self, "change_button", [new_button])
	
	last_button = button_list[0]
	last_button.select()
	emit_signal("load_task", last_button.task_list)

func change_button(new_button):
	last_button.deselect()
	last_button = new_button
	new_button.select()
	emit_signal("load_task", new_button.task_list)
	
	
