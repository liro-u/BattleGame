extends TextureButton
class_name RechargeMana



func _on_RechargeMana_pressed():
	var active_battler = get_tree().get_nodes_in_group("turn_queue")[0].active_battler
	get_tree().get_nodes_in_group("action_gui")[0].disabled_all_button()
	active_battler.recharge_mana()
