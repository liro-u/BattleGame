extends Node
class_name BaseConditionVictory

enum {VICTORY, DEFEAT, GAME_EQUALITY, NOT_FINISHED}

const state2text = {
	VICTORY:"VICTORY",
	DEFEAT:"DEFEAT",
	GAME_EQUALITY:"GAME EQUALITY",
}

func victory_result():
	if get_tree().get_nodes_in_group("charact").size() > 0:
		if get_tree().get_nodes_in_group("team0").size() > 0 and get_tree().get_nodes_in_group("team1").size() > 0 :
			return NOT_FINISHED
		else:
			if  get_tree().get_nodes_in_group("team0").size() > 0:
				return VICTORY
			else:
				return DEFEAT
	else:
		return GAME_EQUALITY
