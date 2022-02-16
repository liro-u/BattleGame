tool
extends YSort
class_name TurnQueue

#----------VARIABLES-------#
var active_battler

#--------FUNCTIONS----------#
#init
func initialize() -> void:
	if get_child_count() > 0:
		var battlers = get_children()
		battlers.sort_custom(self, "sort_battlers")
		for battler in battlers:
			battler.raise()
		active_battler = get_child(get_child_count() - 1)

#sort custom
static func sort_battlers(a , b) -> bool :
	return a.stats.speed > b.stats.speed

#get next battler
func get_next_battler() -> void:
	var new_index : int = (active_battler.get_index() + 1 ) % get_child_count()
	active_battler = get_child(new_index)
