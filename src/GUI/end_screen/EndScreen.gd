extends VBoxContainer

onready var anim_player = $AnimationPlayer
var is_hide = true

func change_visible_state():
	if is_hide:
		show()
		is_hide = false
		anim_player.current_animation = "appear"
		yield(anim_player, "animation_finished")
	else:
		hide()
		is_hide = true
		yield(get_tree(), "idle_frame")
