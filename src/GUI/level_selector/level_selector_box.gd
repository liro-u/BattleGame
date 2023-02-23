extends VBoxContainer

onready var last_sep = $HSeparator2
var next_right
	
func initialize(chap):
	next_right = false
	var path = Global.dataFolderPreset + "://player_data/level_data/story/" + chap
	for index in range(1, get_child_count() - 1):
		get_child(index).queue_free()
	var level_path = SaverInventory.get_all_file(path)
	var first_new_node = true
	for level_data in level_path:
		if level_data != "chapitre_data.tres":
			if first_new_node:
				first_new_node = false
				create_new_level_select_button(level_data)
			else:
				create_link()
				if next_right:
					create_new_level_select_button(level_data)
				else:
					create_new_level_select_button(level_data)
	move_child(last_sep, get_child_count() - 1)
	
func create_new_level_select_button(level_data):
			var new_button = load("res://src/GUI/level_selector/level_button.tscn").instance()
			add_child(new_button)
			if next_right:
				new_button.set_right()
			else:
				new_button.set_left()
			new_button.initialize(level_data.replace("level_", ""))

func create_link():
	var new_link = load("res://src/GUI/level_selector/seperator_level.tscn").instance()
	add_child(new_link)
	if next_right:
		new_link.set_right_to_left()
	else:
		new_link.set_left_to_right()
	next_right = !next_right
	

