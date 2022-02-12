tool
extends YSort
class_name TurnQueue

var active_battler

func initialize():
	var battlers = get_children()
	battlers.sort_custom(self, "sort_battlers")
	for battler in battlers:
		battler.raise()
	active_battler = get_child(get_child_count() - 1)

static func sort_battlers(a , b) -> bool :
	return a.stats.speed > b.stats.speed
	
func play_turn():
	get_next_battler()
	active_battler.set_active()
	get_parent().GUI.initialize(active_battler)

func get_next_battler():
	for child in get_tree().get_nodes_in_group("charact"):
		child.clickable_area.can_be_selected()
	var more_than_one_team = true
	if more_than_one_team:
		get_next_index()
		while active_battler.stats.health <= 0:
			get_next_index()
		active_battler.stats.print_changing_stats()
	else:
		print("combat_is_over")
	
func get_next_index():
	var new_index : int = (active_battler.get_index() + 1 ) % get_child_count()
	active_battler = get_child(new_index)
