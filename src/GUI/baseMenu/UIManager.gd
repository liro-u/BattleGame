extends Control

func open_ui(param):
	var node = get_node(param[0])
	node.show()
	if node.has_method("load_with_param"):
		node.load_with_param(param[1])
