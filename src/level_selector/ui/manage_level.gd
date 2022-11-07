extends Control

func select_level(chapitre, level):
	for team_selector_ui in get_tree().get_nodes_in_group("team_selector_ui"):
		team_selector_ui.reset()
		team_selector_ui.battler_given =  load("res://asset/level_data/chapitre_" + str(chapitre) + "/level_" + str(level) + "/data.tres").battler_given
		team_selector_ui.show()
		team_selector_ui.leveldata_starter.next_scene_data = ["level", chapitre, level, []]
	
