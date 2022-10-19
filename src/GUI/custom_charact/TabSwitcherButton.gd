extends Button
class_name TabSwitcherButton

export(NodePath) onready var nodeRef
signal set_tab_to_main(nodeRef)

func _ready():
	connect("pressed", self, "set_tab")

func set_tab():
	emit_signal("set_tab_to_main", get_node(nodeRef))
