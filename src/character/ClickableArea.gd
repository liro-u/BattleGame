extends Area2D
class_name ClickableArea

#-----------VARIABLES-------------#
export var collision_shape : Shape2D = null setget set_collision_shape
export var collision_position : Vector2 = Vector2.ZERO setget set_collision_position
#loaded node path
var collision

#-----------SETGET------------#
func set_collision_shape(new_value: Shape2D = collision_shape) -> void:
	collision_shape = new_value
	collision.shape = collision_shape

func set_collision_position(new_value : Vector2 = collision_position) -> void:
	collision_position = new_value
	collision.position = collision_position

#------------FUNCTION-----------#
#init
func _init() -> void:
	if collision:
		collision.queue_free()
	collision = CollisionShape2D.new()
	add_child(collision)

#ready
func _ready() -> void:
	initialize()

#initialize node
func initialize() -> void:
	connect("input_event", self, "area_is_clicked")

#verify if clickable area can be clicked
func can_be_selected() -> void:
	pass

func area_is_clicked(_viewport, event, _shape_idx) -> void:
	if event.is_action_pressed("select"):
		if ! get_tree().is_input_handled():
			get_tree().set_input_as_handled()
			#make action when clicked here
