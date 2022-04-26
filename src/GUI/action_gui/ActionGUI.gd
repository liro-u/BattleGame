extends AnimGUI

onready var charact_icon = $CharactIcon
onready var charact_name = $VBoxContainer/Name
onready var attack_container = $VBoxContainer/AttackContainer
onready var mana_bar = $VBoxContainer/ManaBar

func set_is_processing(new_value : bool = is_processing) -> void:
	is_processing = new_value
	disabled_all_button()

func setup_with_charact(charact = null):
	if charact != null:
		charact_name.text = charact.ownerStats.stats_reference.name_char
		charact_icon.texture = charact.ownerStats.stats_reference.large_icon
		charact_icon.rect_min_size.x = charact.ownerStats.stats_reference.X_size_large_icon
		charact_icon.rect_size.x = charact_icon.rect_min_size.x
		#mana bar
		mana_bar.initialize(int(charact.stats.max_mana))
		mana_bar.set_value(0)
		mana_bar.update_value(int(charact.stats.mana))
		#attack
		var list_atk = charact.attack.active_attack
		var atk_nodes = attack_container.get_children()
		for i in range(0, atk_nodes.size()):
			if list_atk.size() > i:
				atk_nodes[i].show()
				atk_nodes[i].setup_from_attack(list_atk[i])
			else:
				atk_nodes[i].hide()

func disabled_all_button() -> void:
	for child in attack_container.get_children():
		child.button.disabled = true
