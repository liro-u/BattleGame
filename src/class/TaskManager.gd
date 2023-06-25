extends Node
class_name TaskManager

class TaskUpdater:
	var tree
	var list_node_category = []
	
	func _init(tree_ref):
		tree = tree_ref
		load_task_category()

	func load_task_category():
		var global_task_path = Global.dataFolderPreset + "://player_data/task/"
		var task_categorys = SaverInventory.get_all_file(global_task_path)
		
		for task_category_name in task_categorys:
			var task_category_data = load(global_task_path + task_category_name)
			#create new node
			var new_node_category = TaskCategory.new(task_category_data, tree)
			Global.add_child(new_node_category)
			list_node_category.append(new_node_category)

	func check_task_update(current_timestamp):
		for node_category in list_node_category:
			node_category.check_task_update(current_timestamp)
