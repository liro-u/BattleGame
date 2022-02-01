tool
extends Node2D
class_name Mesh2D

export(Resource) var ske setget set_ske
export(bool) var flipX = false setget set_flipX
export(bool) var debug = false setget set_debug

export(bool) var play = true setget set_play
export(String, "idle", "fixed") var process_mode = "idle" setget set_process_mode
export(float, -5, 5) var speed = 1 setget set_speed
export(String, "animtion0", "none", "idle", "attack", "take_damage") var starting_animation = "none" setget set_starting_animation

var dragon_bones : GDDragonBones

var curr_animation = starting_animation
export(Dictionary) var next_animation = {
	"animtion0": "animtion0",
	"idle": "idle",
	"attack": "idle",
	"take_damage": "idle"
}

func _init():
	for child in get_children():
		if child is GDDragonBones:
			child.queue_free()
	dragon_bones = GDDragonBones.new()
	add_child(dragon_bones)

func _ready():
	dragon_bones.connect("dragon_anim_complete", self, "next_logical_animation")
	curr_animation = starting_animation

func set_debug(new_value : bool) -> void:
	debug = new_value
	dragon_bones.set("debug", debug)

func set_flipX(new_value : bool) -> void:
	flipX = new_value
	dragon_bones.set("flipX", flipX)

func set_ske(new_value : Resource) -> void:
	ske = new_value
	dragon_bones.set("resource", ske)

func set_process_mode(new_value : String) -> void:
	process_mode = new_value
	dragon_bones.set("playback/process_mode", process_mode)

func set_speed(new_value):
	speed = stepify(new_value, 0.01)
	dragon_bones.set("playback/speed", speed)

func set_play(new_value : bool) -> void:
	play = new_value
	dragon_bones.set("playback/play", play)

func set_starting_animation(new_value):
	starting_animation = new_value
	curr_animation = starting_animation
	if play:
		travel(curr_animation)

#animation function
func next_logical_animation(anim) -> void:
	curr_animation = next_animation[anim]
	travel(curr_animation)
	
func travel(anim : String) -> void:
	if dragon_bones.has(anim):
		dragon_bones.play_new_animation(anim, 1)
	else:
		print_debug("no animation named %s in %s" % [anim, dragon_bones])
	
