extends Node
class_name SaverInventory

static func AddNewObject(object):
	object = object.duplicate()
	var path = "res://player_data/inventaire/"
	
	#get all existing file
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

	#check if object already exist
	var new_file_name = object.objet.object_name.replace(" ", "_") + ".tres"
	var last_file = null
	for file in files:
		if new_file_name == file:
			last_file = load(path + file)
			break
	
	#if there is an existing object before, add its quantity to the new one
	if last_file:
		object.quantity += last_file.quantity
	
	#check if object quantity dosen't exced max_quantity (if max_quantity != 1)
	if object.objet.max_quantity > -1:
		object.quantity = min(object.quantity, object.objet.max_quantity)
	
	#save the new object
	ResourceSaver.save(path + new_file_name, object)
