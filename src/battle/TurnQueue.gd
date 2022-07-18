tool
extends YSort
class_name TurnQueue

#----------VARIABLES-------#
var active_battler
var active_battler_index
var turn_indicator
var turn_indicator_size : int = 400
var turn_indicator_start : Vector2 = Vector2(20, 0)
var turn_indicator_end : Vector2 = Vector2(-130, 0)
var turn_indicator_duration : float = 0.2
var last_children = []

#--------FUNCTIONS----------#
func _init():
	turn_indicator = MovableTexture.new(turn_indicator_start, turn_indicator_end, turn_indicator_duration, Vector2(turn_indicator_size, turn_indicator_size))
	turn_indicator.state_is_start = false
	add_to_group("turn_queue")

#reparent turn indicator
func move_turn_indicator():
	active_battler.turn_indicator.add_child(turn_indicator)
	turn_indicator.reset()

#init
func initialize() -> void:
	if get_child_count() > 0:
		var battlers = get_children()
		battlers.sort_custom(self, "sort_battlers")
		for battler in battlers:
			battler.raise()
		active_battler = get_child(0)
		active_battler_index = active_battler.get_index()
		play_turn()

#sort custom
static func sort_battlers(a , b) -> bool :
	return a.stats.speed > b.stats.speed

func end_turn():
	if turn_indicator.is_inside_tree():
		turn_indicator.get_parent().remove_child(turn_indicator)
	last_children = get_children().duplicate()
	active_battler.end_turn()
	get_tree().call_group_flags(2, "remove_battler_from_world", "remove_from_world")
	
#get next battler
func get_next_battler() -> void:
	var new_index = (active_battler_index + 1 ) % last_children.size()
	while (! last_children[new_index].is_inside_tree()):
		new_index = (new_index + 1 ) % last_children.size()
	var next_battler_to_add = get_child((active_battler_index + get_parent().battleGUI.turnline.max_nbr_case) % get_child_count())
	
	active_battler = get_child(get_children().find(last_children[new_index]))
	active_battler_index = active_battler.get_index()
	get_parent().battleGUI.turnline.replace_case_by(next_battler_to_add)
	play_turn()
	
func play_turn():
	active_battler.ask_action_turn()
	move_turn_indicator()
