extends Node

func _physics_process(delta):
	if Input.is_action_just_pressed("dev_take_damage"):
		get_parent().take_damage(load("res://asset/attack/fire_blast.tres"))
	if Input.is_action_just_pressed("dev_grab_health"):
		get_parent().take_damage(load("res://asset/attack/green_bump.tres"))
	if Input.is_action_just_pressed("dev_up_level"):
		up_level()
	if Input.is_action_just_pressed("dev_down_level"):
		down_level()
		
func up_level():
	get_parent().ownerStats.level += 1
	get_parent().mesh.queue_free()
	get_parent().initialize()

func down_level():
	get_parent().ownerStats.level -= 1
	get_parent().mesh.queue_free()
	get_parent().initialize()

