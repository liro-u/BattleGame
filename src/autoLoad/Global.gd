extends Node

var dataFolderPreset = "user"

var stamina_updater

func _ready():
	SaverInventory.first_creation_data()
	stamina_updater = StaminaManager.StaminaUpdater.new(get_tree())

func _physics_process(delta):
	stamina_updater.check_stamina_update()
