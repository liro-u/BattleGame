extends Node

var dataFolderPreset = "user"

var stamina_updater
	
func _ready():
	SaverInventory.first_creation_data()
	stamina_updater = StaminaManager.StaminaUpdater.new(get_tree())
	load_task()

func _physics_process(delta):
	stamina_updater.check_stamina_update()

func load_task():
	var global_task_path = "res://player_data/task/"
	var task_folders = SaverInventory.get_all_file(global_task_path)
	
	for task_list in task_folders:
		var task_list_data = load(global_task_path + task_list)
		#create new node
		var new_node = Node.new()
		add_child(new_node)
		new_node.name = task_list.replace(".tres", "")
		#create task node
		for dat_task in task_list_data.task_list:
			var new_task
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
			new_node.add_child(new_task)
	#load one by one by enter path presave
	
	#load all folder and assign a dictionary with as key the name of each folder and as value the list of task
