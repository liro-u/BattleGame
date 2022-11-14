extends TextureRect

export(Array, Resource) var list_monnaie

onready var bar_box = $MarginContainer/TopBarre

func _ready():
	initialize()

func initialize():
	for child in bar_box.get_children():
		child.queue_free()
	var monnaie_box_instance = load("res://src/GUI/baseMenu/monnaie_bar/monnaie.tscn")
	for monnaie in list_monnaie:
		var monnaie_node = monnaie_box_instance.instance()
		bar_box.add_child(monnaie_node)
		monnaie_node.initialize(monnaie)
		
func update_data():
	initialize()
