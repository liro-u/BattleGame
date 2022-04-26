extends Control
class_name ActionStateMachine

onready var action_gui = $ActionGUI
onready var select_target = $SelectTarget
onready var starting_gui = action_gui
export var start_gui = "choose_action"
onready var active_gui = starting_gui
var past_gui = []
var last_gui = null
var current_state = start_gui
export var all_gui = ["end_turn", "choose_action", "select_target"]
var is_processing = false
export var states = {
	"end_turn":["choose_action"],
	
	"choose_action":["select_target"],
	
	"select_target":["end_turn"],
}

func set_gui(next_gui):
	if ! is_processing:
		if next_gui == current_state:
			print ("AnimationPlayer_manager.gd -- WARNING: animation is already ", next_gui)
			return true
		if next_gui in all_gui:
			if current_state != null:
				var possible_next_gui = states[current_state]
				if next_gui in possible_next_gui:
					past_gui.append(current_state)
					last_gui = current_state
					current_state = next_gui
					switch_gui()
					return true
				else:
					print ("AnimationPlayer_Manager.gd -- WARNING: cannot change to ", next_gui, " from ",current_state)
					return true
			else:
				past_gui.append(current_state)
				last_gui = current_state
				current_state = next_gui
				switch_gui()
				return true
	return false

func _ready():
	call_deferred("initialize")

func initialize():
	for node in get_tree().get_nodes_in_group("ui_cancel"):
		node.connect("pressed", self, "get_last_gui")
	manage_ui_cancel()
	switch_anim_ended()

func switch_gui() -> void:
	yield(switch_anim_started(), "completed")
	get_next_gui()
	yield(switch_anim_ended(), "completed")

#state 2
func switch_anim_ended() -> void:
	is_processing = false
	get_tree().call_group_flags(2, "ui_cancel", "activate")
	
	if active_gui.has_method("change_visible_state"):
		yield(active_gui.change_visible_state(), "completed")
	else:
		active_gui.show()
		active_gui.is_hide = ! active_gui.is_hide
	
	match current_state:
		"choose_action":
			var active_battler = get_tree().get_nodes_in_group("turn_queue")[0].active_battler
			for node in get_tree().get_nodes_in_group("active_attack"):
				node.remove_from_group("active_attack")
			for node in get_tree().get_nodes_in_group("charact"):
				if node != active_battler:
					node.shade()
		"select_target":
			var active_battler = get_tree().get_nodes_in_group("turn_queue")[0].active_battler
			var active_attack = get_tree().get_nodes_in_group("active_attack")[0]
			for node in get_tree().get_nodes_in_group("charact"):
				if ((node.team == active_battler.team) and active_attack.target_enemy) or ((node.team != active_battler.team) and not active_attack.target_enemy):
					node.shade()
				else:
					node.clickable_area.add_to_group("active_clickable_area")
					node.clickable_area.collision.disabled = false

#state 1
func switch_anim_started() -> void:
	is_processing = true
	get_tree().call_group_flags(2, "ui_cancel", "desactivate")
	
	if active_gui.has_method("change_visible_state"):
		yield(active_gui.change_visible_state(), "completed")
	else:
		active_gui.hide()
		active_gui.is_hide = ! active_gui.is_hide
	
	manage_ui_cancel()

	match last_gui:
		"choose_action":
			get_tree().call_group_flags(2, "charact", "unshade")
		"select_target":
			get_tree().call_group_flags(2, "charact", "unshade")
			for node in get_tree().get_nodes_in_group("active_clickable_area"):
				node.remove_from_group("active_clickable_area")
				node.collision.disabled = true

func manage_ui_cancel():
	match current_state:
		"end_turn":
			get_tree().call_group_flags(2, "ui_cancel", "disappear")
		"choose_action":
			get_tree().call_group_flags(2, "ui_cancel", "disappear")
		"select_target":
			get_tree().call_group_flags(2, "ui_cancel", "appear")

func get_next_gui():
	match current_state:
		"end_turn":
			past_gui = []
			end_turn()
			active_gui = starting_gui
			current_state = start_gui
		"choose_action":
			active_gui = action_gui
		"select_target":
			active_gui = select_target

func get_last_gui() -> void:
	if past_gui.size() > 0 and ! is_processing:
		last_gui = current_state
		current_state = past_gui.pop_back()
		switch_gui()
	
func end_turn():
	get_tree().call_group("turn_queue", "get_next_battler")
