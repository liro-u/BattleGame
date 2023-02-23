extends VBoxContainer

func initialize(chap):
	for child in get_children():
		child.queue_free()
	var path = Global.dataFolderPreset + "://player_data/level_data/story/"
	var level_path = SaverInventory.get_all_file(path)
	for p in level_path:
		var new_node = load("res://src/GUI/level_selector/ButtonLevelChapter.tscn").instance()
		var chapter_data = load(Global.dataFolderPreset + "://player_data/level_data/story/" + p + "/chapitre_data.tres")
		add_child(new_node)
		new_node.connect("is_clicked", get_tree().get_nodes_in_group("chapitre_ui")[0], "refresh_chapter")
		new_node.chapitre = p
		new_node.set_active(chap == p)
		new_node.initialize(chapter_data)
		
