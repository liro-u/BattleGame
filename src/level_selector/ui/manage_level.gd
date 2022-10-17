extends Control
onready var team_selector = $"../team_selector"
onready var leveldata_starter = $"../team_selector/UI/Start/Start/SwitchSceneData"

func select_level(chapitre, level):
	team_selector.reset()
	team_selector.battler_given =  load("res://asset/level_data/chapitre_" + str(chapitre) + "/level_" + str(level) + "/data.tres").battler_given
	team_selector.show()
	leveldata_starter.next_scene_data = ["level", chapitre, level, []]
	
