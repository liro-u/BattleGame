extends Control

var chapitre = 1
 
func select_level(level, data_level):
	for team_selector_ui in get_tree().get_nodes_in_group("team_selector_ui"):
		team_selector_ui.reset()
		team_selector_ui.leveldata_starter.next_scene_data = ["level", chapitre, level, []]
		#force given team
		if data_level.team_given.size() > 0:
			team_selector_ui.set_team(data_level.team_given)
		#let player choose team
		else:
			team_selector_ui.battler_given = data_level.battler_given
		team_selector_ui.show()
	
