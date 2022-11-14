extends Control

func back():
	hide()
	get_tree().call_group_flags(2, "update_data", "update_data")
