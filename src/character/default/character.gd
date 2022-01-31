tool
extends Node2D

onready var stats = $Stats
onready var character_gui = $CharacterGUI
onready var attack = $Attack
onready var clickable_area = $ClickableArea
var mesh
var anim_tree

export var startingStats : Resource
export var ownerStats : Resource
export var team : int

func _ready():
	initialize()
	
func initialize():
	stats.initialize(startingStats, ownerStats)
	character_gui.initialize(stats)
	attack.initialize(stats)
	
	mesh = load(stats.skin_path).instance()
	if team != 0:
		mesh.get_node("model/main").flip_h = not mesh.get_node("model/main").flip_h
	add_child(mesh)
	anim_tree = mesh.get_node("AnimationTree")

func play_anim(param):
	anim_tree.get("parameters/playback").travel(param)
	yield(anim_tree, "end")
	
func shade(param):
	if param:
		modulate = Color.white * 0.3
		modulate.a = 1
	else:
		modulate = Color.white
		
func take_damage(hit):
	stats.take_damage(hit)

func unset_active():
	if is_in_group("active"):
		remove_from_group("active")
		$active_sprite.hide()
	
func set_active():
	get_tree().call_group_flags(2, "active", "unset_active")
	add_to_group("active")
	$active_sprite.show()
	
	
	
	
	
