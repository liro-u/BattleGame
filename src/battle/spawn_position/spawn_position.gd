tool
extends Node2D
class_name SpawnPosition

export(Array, Resource) var list_team_position

func initialize(list_battlers):
	for team_pos in list_team_position:
		add_child(team_pos.instance())
	for battler in list_battlers:
		battler.position = get_children()[battler.stats.team].get_next_pos()
	
