extends Node
class_name SaverInventory

static func get_all_file(path):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append(file)
	dir.list_dir_end()
	return files

static func check_existing_resource(new_file_name, files, path):
	var last_file = null
	for file in files:
		if new_file_name == file:
			last_file = load(path + file)
			break
	return last_file

static func addNewMonnaie(monnaie):
	var path = "res://player_data/monnaie/"
	addNewThings(monnaie, path)
	
static func addNewObject(object):
	var path = "res://player_data/inventaire/"
	addNewThings(object, path)

static func addNewThings(newThings, path):
	newThings = newThings.duplicate()
	var new_file_name = newThings.things.things_name.replace(" ", "_") + ".tres"
	var max_quantity = newThings.things.max_quantity
	#get all existing file
	var files = get_all_file(path)
	#check if things already exist
	var last_file = check_existing_resource(new_file_name, files, path)
	#if there is an existing things before, add its quantity to the new one
	if last_file:
		newThings.quantity += last_file.quantity
	#check if things quantity dosen't exced max_quantity (if max_quantity != 1)
	if max_quantity > -1:
		newThings.quantity = min(newThings.quantity, max_quantity)
	#save the new things
	print(path + new_file_name, " -- ", newThings.resource_path)
	ResourceSaver.save(path + new_file_name, newThings)

static func tryRemoveStamina(nb_stam):
	var current_stamina = load("res://player_data/monnaie/stamina.tres")
	if current_stamina.quantity >= nb_stam:
		current_stamina.quantity -= nb_stam
		ResourceSaver.save(current_stamina.resource_path, current_stamina)
		return true
	return false
