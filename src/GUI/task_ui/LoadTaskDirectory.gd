extends VBoxContainer

var task_path = Global.dataFolderPreset + "://player_data/task/"
var button_instance = load("res://src/GUI/task_ui/task_tab.tscn")

var button_list = []
var last_button
var task_bar_progression

signal load_task

class CustomSorter:
	
	func filter_by_priority(a, b):
		if a.priority < b.priority:
			return true
		return false
		
func _ready():
	button_list = get_children()
	
func initialize(tBP):
	task_bar_progression = tBP
	for child in button_list:
		child.queue_free()
	button_list = []
		
	var task_folders = SaverInventory.get_all_file(task_path)
	var task_array = []
	for folder in task_folders:
		task_array.append(load(task_path + folder))
	task_array.sort_custom(CustomSorter.new(), "filter_by_priority")
	for task_data in task_array:
		var new_button = button_instance.instance()
		new_button.text = task_data.task_list_name
		button_list.append(new_button)
		new_button.task_data = task_data
		
		add_child(new_button)
		new_button.connect("pressed", self, "change_button", [new_button])
	last_button = button_list[0]
	last_button.select()
	load_task()

func change_button(new_button):
	last_button.deselect()
	last_button = new_button
	new_button.select()
	load_task()
	
func load_task():
	task_bar_progression.initialize(last_button.task_data.nb_task_claimed, last_button.task_data.nb_task_to_claim)
	emit_signal("load_task", last_button.task_data.task_list, self)
	
func save_task():
	last_button.task_data.nb_task_claimed += 1
	task_bar_progression.tween_to_value(last_button.task_data.nb_task_claimed)
	ResourceSaver.save(last_button.task_data.resource_path, last_button.task_data)
