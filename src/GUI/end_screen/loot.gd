extends GridContainer

var loot_list = []
var loot_index = 0
export var max_loot_on_screen = 10
export(PackedScene) var loot_node_instance

signal all_loot_printed


func _ready():
	#create n node for loot
	for child in get_children():
		child.queue_free()
	for i in range(0, max_loot_on_screen):
		var new_loot_node = loot_node_instance.instance()
		add_child(new_loot_node)
		
func initialize(loot_arr, node_call_back):
	loot_list = loot_arr
	loot_index = 0
	connect("all_loot_printed", node_call_back, "show_charact_final")
	
func next_loot():
	while (loot_index < loot_list.size()):
		for i in range(0, max_loot_on_screen):
			if loot_index < loot_list.size():
				yield(get_tree().create_timer(0.2), "timeout")
				show_next_loot(loot_list[loot_index])
				loot_index += 1
		yield(get_tree().create_timer(2), "timeout")
		hide_all()
	if loot_list.size() > 0:
		yield(get_tree().create_timer(1), "timeout")
	emit_signal("all_loot_printed")

func show_next_loot(loot):
	var node_to_show = get_children()[loot_index % max_loot_on_screen]
	node_to_show.texture.texture = loot.objet.texture
	node_to_show.appear()

func hide_all():
	for child in get_children():
		child.disappear()
