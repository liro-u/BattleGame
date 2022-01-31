extends Node2D
class_name weapon

export(NodePath) var weaponPoint_path
onready var weaponPoint = get_node(weaponPoint_path)

func _ready():
	set_physics_process(false)
	
func initialize():
	set_physics_process(true)
	
func _physics_process(delta):
	global_transform = weaponPoint.global_transform
