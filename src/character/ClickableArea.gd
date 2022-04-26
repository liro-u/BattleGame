extends Area2D
class_name ClickableArea

#-----------VARIABLES-------------#
export var collision_shape : Shape2D = null setget set_collision_shape
export var collision_position : Vector2 = Vector2.ZERO setget set_collision_position
export var is_under : bool = false
export var global_click : bool = false
#loaded node path
var collision
var in_queue : int = 0
signal pressed

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
	collision.disabled = true
	add_child(collision)
	connect("input_event", self, "area_is_clicked")
	add_to_group("over_clickable_area")

#initialize node
func initialize() -> void:
	if is_under:
		remove_from_group("over_clickable_area")
		var all_area = get_tree().get_nodes_in_group("over_clickable_area")
		for area in all_area:
			area.connect("mouse_entered", self, "add_in_queue", [1])
			area.connect("mouse_exited", self, "add_in_queue", [-1])

func add_in_queue(n : int = 0) -> void:
	in_queue += n
	if in_queue == 0:
		activate()
	else:
		desactivate()

func area_is_clicked(_viewport, event, _shape_idx) -> void:
	if event.is_action_pressed("select"):
		if ! get_tree().is_input_handled():
			if ! global_click:
				get_tree().set_input_as_handled()
			emit_signal("pressed")

func desactivate():
	collision.disabled = true

func activate():
	collision.disabled = false

func disappear():
	hide()

func appear():
	show()
