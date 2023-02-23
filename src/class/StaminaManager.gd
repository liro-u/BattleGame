extends Node
class_name StaminaManager

static func tryRemoveStamina(nb_stam):
	if check_enought_stamina(nb_stam):
		var current_stamina = load(Global.dataFolderPreset + "://player_data/monnaie/stamina.tres")
		if current_stamina.quantity >= current_stamina.things.max_quantity:
			Global.stamina_updater.update_last_stamina_claim(OS.get_unix_time())
		current_stamina.quantity -= nb_stam
		ResourceSaver.save(current_stamina.resource_path, current_stamina)
		return true
	return false

static func check_enought_stamina(nb_stam):
	var current_stamina = load(Global.dataFolderPreset + "://player_data/monnaie/stamina.tres")
	if current_stamina.quantity >= nb_stam:
		return true
	return false
	
static func load_stamina_cost(chapitre, level):
	var data = load(Global.dataFolderPreset + "://player_data/level_data/story/chapitre_" + str(chapitre) + "/level_" + str(level) + "/data.tres")
	return data.stamina_cost

class StaminaUpdater:
	var current_stamina
	var client_data
	var tree
	
	func _init(tree_ref):
		tree = tree_ref
		init_stamina()
	
	func update_last_stamina_claim(new_time_stamp):
		#update time stamp
		client_data.last_stamina_claim = new_time_stamp
		ResourceSaver.save(client_data.resource_path, client_data)

	func add_n_stamina(n):
		var stam_gain = current_stamina.duplicate()
		stam_gain.quantity = n
		SaverInventory.addNewThings(stam_gain)
		tree.call_group("stamina_updater", "update")
		
	func init_stamina():
		current_stamina = load(Global.dataFolderPreset + "://player_data/monnaie/stamina.tres")
		client_data = load(Global.dataFolderPreset + "://player_data/client/client_data.tres")
		var current_timestamp = OS.get_unix_time()
		if client_data.last_stamina_claim < 0 or client_data.last_stamina_claim > current_timestamp:
			update_last_stamina_claim(current_timestamp)

	func check_stamina_update():
		while current_stamina.quantity < current_stamina.things.max_quantity and client_data.last_stamina_claim + client_data.duration_gain_stamina <= OS.get_unix_time():
			update_last_stamina_claim(client_data.last_stamina_claim + client_data.duration_gain_stamina)
			add_n_stamina(1)
		
