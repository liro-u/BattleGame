extends Area2D
class_name ClickableArea

onready var charact = get_parent()

func can_be_selected(target_team = -1, equal = false):
	var b_disabled
	if ((target_team == charact.team and equal and (charact.stats.health < charact.stats.max_health)) or (target_team != charact.team and not equal)) and charact.stats.health > 0 :
		b_disabled = false
	else:
		b_disabled = true
	charact.shade(b_disabled)
	if target_team == -1:
		b_disabled = true
	for child in get_children():
		child.disabled = b_disabled
	if b_disabled:
		return null
	else:
		return charact

func _on_ClickableArea_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("select"):
		if ! get_tree().is_input_handled():
			charact.get_parent().get_parent().GUI.target_selected(charact)
			get_tree().set_input_as_handled()
