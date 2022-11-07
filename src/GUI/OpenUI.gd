extends BaseButton

export var ui_group = ""

func _ready():
	connect("pressed", self, "open_ui")

func open_ui():
	for ui in get_tree().get_nodes_in_group(ui_group):
		if ui.has_method("initialize"):
			ui.initialize()
		ui.show()
