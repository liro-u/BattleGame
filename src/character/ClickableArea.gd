extends Area2D
class_name ClickableArea

#-----------VARIABLES-------------#
export var collision_shape : Shape2D = null setget set_collision_shape
export var collision_position : Vector2 = Vector2.ZERO setget set_collision_position
export var global_click : bool = false
#loaded node path
var collision
signal pressed

#-----------SETGET------------#
func set_collision_shape(new_value: Shape2D = collision_shape) -> void:
	collision_shape = new_value
	collision.shape = collision_shape

func set_collision_position(new_value : Vector2 = collision_position) -> void:
	collision_position = new_value
	collision.position = collision_position

#------------FUNCTION-----------#
func custom_sort(a, b):
	return a.priority > b.priority

#init
func _init() -> void:
	if collision:
		collision.queue_free()
	collision = CollisionShape2D.new()
	collision.disabled = true
	add_child(collision)
	connect("input_event", self, "area_is_clicked")
	priority = 1
	
func area_is_clicked(_viewport, event, _shape_idx) -> void:
	if collision.disabled == false:
		if event.is_action_pressed("select"):
			if ! get_tree().is_input_handled():
				var space = get_world_2d().direct_space_state
				var list_area = []
				for area_dic in space.intersect_point(event.position, 32, [], 2147483647, false, true):
					list_area.append(area_dic.collider)
				list_area.sort_custom(self, "custom_sort")
				list_area[0].is_pressed(event)
				for area in list_area:
					area.desactivate()
		
func is_pressed(event):
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
