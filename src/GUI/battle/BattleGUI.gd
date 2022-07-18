tool
extends Control
class_name BattleGUI

#-------VARIABLES-----#
#loaded node path
onready var turnline = $Panel/TurnLine
onready var action_state_machine = $ActionStateMachine

#-------FUNCTIONS----#
#init
func initialize(turn_queue : TurnQueue) -> void:
	turnline.initialise(turn_queue.get_children(), turn_queue.active_battler_index)
	
