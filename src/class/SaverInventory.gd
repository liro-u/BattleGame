extends Node
class_name SaverInventory

static func copy_directory_recursively(p_from : String, p_to : String) -> void:
	var directory = Directory.new()
	if not directory.dir_exists(p_to):
		directory.make_dir_recursive(p_to)
	if directory.open(p_from) == OK:
		directory.list_dir_begin(true)
		var file_name = directory.get_next()
		while (file_name != "" && file_name != "." && file_name != ".."):
			if directory.current_is_dir():
				copy_directory_recursively(p_from + "/" + file_name, p_to + "/" + file_name)
			else:
				directory.copy(p_from + "/" + file_name, p_to + "/" + file_name)
			file_name = directory.get_next()
	else:
		push_warning("Error copying " + p_from + " to " + p_to)
		
static func first_creation_data():
	var destination = "user://player_data/"
	var directory = Directory.new();
	if not directory.dir_exists(destination):
		var source = "res://player_data/"
		copy_directory_recursively(source, destination)
	
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
	var path = Global.dataFolderPreset + "://player_data/monnaie/"
	addNewThings(monnaie, path)
	
static func addNewObject(object):
	var path = Global.dataFolderPreset + "://player_data/inventaire/"
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
		last_file.quantity += newThings.quantity
	else:
		last_file = newThings
	#check if things quantity dosen't exced max_quantity (if max_quantity != 1)
	if max_quantity > -1:
		last_file.quantity = min(last_file.quantity, max_quantity)
	#save the new things
	ResourceSaver.save(last_file.resource_path, last_file)
