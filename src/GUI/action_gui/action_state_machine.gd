extends Control
class_name ActionStateMachine

onready var action_gui = $ActionGUI
onready var select_target = $SelectTarget
onready var starting_gui = action_gui
export var start_gui = "choose_action"
onready var active_gui = starting_gui
onready var end_screen = $EndScreen
onready var message_gui = $MessageGui
var final_loot = []
var past_gui = []
var last_gui = null
var current_state = start_gui
export var all_gui = ["end_turn", "choose_action", "select_target", "end_game", "message_gui"]
var is_processing = false
var state_of_game = BaseConditionVictory.NOT_FINISHED
export var states = {
	"end_turn":["choose_action", "message_gui"],
	
	"choose_action":["select_target", "end_turn"],
	
	"select_target":["end_turn"],
	
	"end_game":[],
	
	"message_gui":["end_turn"],
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
	if  get_tree().get_nodes_in_group("turn_queue")[0].active_battler.team == 0:
		current_state = start_gui
		active_gui = starting_gui
	else:
		current_state = "message_gui"
		active_gui = message_gui
		message_gui.get_node("Label").text = "Tour de l'adversaire"
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
	if active_gui.has_method("change_visible_state"):
		yield(active_gui.change_visible_state(), "completed")
	else:
		yield(get_tree(), "idle_frame")
		active_gui.show()
		if "is_hide" in active_gui:
			active_gui.is_hide = ! active_gui.is_hide
	match current_state:
		"choose_action":
			get_tree().get_nodes_in_group("action_gui")[0].disabled_all_button(false)
			var active_battler = get_tree().get_nodes_in_group("turn_queue")[0].active_battler
			for node in get_tree().get_nodes_in_group("active_attack"):
				node.remove_from_group("active_attack")
			for node in get_tree().get_nodes_in_group("charact"):
				if node != active_battler:
					node.shade()
		"message_gui":
			for node in get_tree().get_nodes_in_group("active_attack"):
				node.remove_from_group("active_attack")
			get_tree().get_nodes_in_group("turn_queue")[0].active_battler.play_auto()
		"select_target":
			var active_battler = get_tree().get_nodes_in_group("turn_queue")[0].active_battler
			var active_attack = get_tree().get_nodes_in_group("active_attack")[0]
			for node in get_tree().get_nodes_in_group("charact"):
				if ((node.team == active_battler.team) and active_attack.target_enemy) or ((node.team != active_battler.team) and not active_attack.target_enemy):
					node.shade()
				else:
					node.clickable_area.add_to_group("active_clickable_area")
					node.clickable_area.collision.disabled = false
		"end_game":
			show_loot()
			
	get_tree().call_group_flags(2, "ui_cancel", "activate")
	is_processing = false

#state 1
func switch_anim_started() -> void:
	is_processing = true
	get_tree().call_group_flags(2, "ui_cancel", "desactivate")
	
	if active_gui.has_method("change_visible_state"):
		yield(active_gui.change_visible_state(), "completed")
	else:
		yield(get_tree(), "idle_frame")
		active_gui.hide()
		if "is_hide" in active_gui:
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
		"message_gui":
			get_tree().call_group_flags(2, "charact", "unshade")
			for node in get_tree().get_nodes_in_group("active_clickable_area"):
				node.remove_from_group("active_clickable_area")

func manage_ui_cancel():
	match current_state:
		"end_turn":
			get_tree().call_group_flags(2, "ui_cancel", "disappear")
		"choose_action":
			get_tree().call_group_flags(2, "ui_cancel", "disappear")
		"select_target":
			get_tree().call_group_flags(2, "ui_cancel", "appear")
		"message_gui":
			get_tree().call_group_flags(2, "ui_cancel", "disappear")

func get_next_gui():
	match current_state:
		"end_turn":
			past_gui = []
			end_turn()
			if state_of_game == BaseConditionVictory.NOT_FINISHED:
				var turn_queue = get_tree().get_nodes_in_group("turn_queue")[0]
				var next_active_battler = turn_queue.get_child((turn_queue.active_battler.get_index() + 1) % turn_queue.get_child_count())
				if next_active_battler.team == 0:
					active_gui = starting_gui
					current_state = start_gui
				else:
					active_gui = message_gui
					message_gui.get_node("Label").text = "Tour de l'adversaire"
					current_state = "message_gui"
			else:
				current_state = "end_game"
				active_gui = end_screen
				get_parent().turnline.disappear()
				
				#show text win / defeat
				$EndScreen/MarginContainer/VBoxContainer/EndText.text = BaseConditionVictory.state2text[state_of_game]
				#get node
				var charact_xp_ui = get_tree().get_nodes_in_group("charact_xp_box")[0].get_children()
				var task_box = get_tree().get_nodes_in_group("task_container")[0].get_children()
				var list_task = get_parent().get_parent().task_list_data
				#show task state
				for task_node in task_box:
					var task = list_task[task_node.get_index()]
					var star_state_node = task_node.get_node("Star").get_node("StateStar")
					star_state_node.appear(task and task.finished)
				#update client level
				var client_data = load("res://player_data/client/client_data.tres")
				var client_level_ui =  get_tree().get_nodes_in_group("client_level")[0]
				var client_xp_label_ui = get_tree().get_nodes_in_group("gain_client_xp")[0]
				var client_player_animation = get_tree().get_nodes_in_group("client_level_player_animation")[0]
				var value_ratio
				if client_data.xp == 0:
					value_ratio = 0
				else:
					value_ratio = (client_data.xp / levelCalculation.xp_needed_for_level(client_data.level + 1, client_data.starting_xp_needed, client_data.level_palier)) * 999
				client_level_ui.set_progress(value_ratio)
				client_level_ui.set_value(client_data.level)
				#if win
				if BaseConditionVictory.VICTORY == state_of_game:
					if client_data.level < client_data.max_level:
						var final_client_data = levelCalculation.add_xp_client(get_parent().get_parent().xp_gain, client_data.duplicate())
						yield(get_tree().create_timer(1), "timeout")
						client_player_animation.current_animation = "hide"
						yield(client_player_animation, "animation_finished")
						client_xp_label_ui.text = "+" + str(get_parent().get_parent().xp_gain) + " EXP"
						if final_client_data.xp == 0:
							value_ratio = 0
						else:
							value_ratio = (final_client_data.xp / levelCalculation.xp_needed_for_level(final_client_data.level + 1, final_client_data.starting_xp_needed, final_client_data.level_palier)) * 999
						client_level_ui.set_progress(value_ratio)
						client_level_ui.set_value(final_client_data.level)
						client_player_animation.current_animation = "show"

						ResourceSaver.save(client_data.resource_path, final_client_data)
					else:
						client_player_animation.current_animation = "max_level"
						client_xp_label_ui.text = "MAX LVL"
				#if win
				if BaseConditionVictory.VICTORY == state_of_game:
					#update xp battler
					var list_team_battler = []
					for node in get_tree().get_nodes_in_group("charact"):
						if node.team == 0:
							list_team_battler.append(node.ownerStats)
					var index = 0
					for team_battler in list_team_battler:
						var final_team_battler = levelCalculation.add_xp(get_parent().get_parent().xp_gain, team_battler.duplicate())
						charact_xp_ui[index].initialize(team_battler, final_team_battler)
						charact_xp_ui[index].add_to_group("active_ui_xp_charact")
						index += 1
						if !team_battler.is_given:
							var path_res = team_battler.resource_path
							final_team_battler.take_over_path(path_res)
							ResourceSaver.save(path_res, final_team_battler)
					#update loot win
					for possible_loot in get_parent().get_parent().loot_table:
						if possible_loot.proba >= randf():
							final_loot.append(possible_loot.loot)
							SaverInventory.AddNewObject(possible_loot.loot)
				else:
					get_tree().call_group_flags(2, "button_next_level", "hide")
				
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
	get_tree().call_group_flags(2, "turn_queue", "end_turn")
	state_of_game = get_tree().get_nodes_in_group("condition_victory")[0].victory_result()
	if state_of_game == BaseConditionVictory.NOT_FINISHED:
		get_tree().call_group("turn_queue", "get_next_battler")

func show_charact_final():
	for node in get_tree().get_nodes_in_group("active_ui_xp_charact"):
		node.show()
		node.set_anim()

func show_loot():
	get_tree().call_group("loot_recap", "initialize", final_loot, self)
	get_tree().call_group("loot_recap", "next_loot")
