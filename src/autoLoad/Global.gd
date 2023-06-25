extends Node

var dataFolderPreset = "user"

var stamina_updater
var task_updater
	
func _ready():
	randomize()
	SaverInventory.first_creation_data()
	stamina_updater = StaminaManager.StaminaUpdater.new(get_tree())
	task_updater = TaskManager.TaskUpdater.new(get_tree())

func _physics_process(delta):
	stamina_updater.check_stamina_update()
	task_updater.check_task_update(OS.get_unix_time())


