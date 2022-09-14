extends Button

signal is_clicked

func _ready():
	connect("pressed", self, "clicked")
	
func clicked():
	var switcher = get_child(0)
	var data = switcher.next_scene_data
	var team_data = data[3]
	data[3] = update_team_data(team_data)
	switcher.next_scene_data = data
	emit_signal("is_clicked")
	
func update_team_data(team_data):
	var index = 0
	for battler in team_data:
		team_data[index] = load(battler.resource_path)
		index += 1
	return team_data
