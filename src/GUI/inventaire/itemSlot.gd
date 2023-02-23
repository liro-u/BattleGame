extends TextureButton
class_name ItemSlot

onready var locked_container = $LockedContainer
onready var item_texture = $ItemContainer/ItemTexture
onready var selected_texture = $SelectedTexture
onready var number_label = $NumberBox/VBoxContainer/BackgroundNumber/MarginContainer/Number
onready var number_box = $NumberBox

var item_data

var is_selected = false

signal is_clicked

func initialize(item):
	selected_texture.hide()
	is_selected = false
	load_item(item)

func load_item(item):
	item_data = item
	if item_data.things.max_quantity != 1:
		number_label.text = str(item_data.quantity)
	else:
		number_box.hide()
	locked_container.visible = item_data.locked
	item_texture.texture = item_data.things.texture

func _on_ItemSlot_pressed():
	get_tree().call_group_flags(2, "selected_item_slot", "deselect")
	add_to_group("selected_item_slot")
	selected_texture.show()
	disabled = true
	emit_signal("is_clicked", item_data)

func deselect():
	remove_from_group("selected_item_slot")
	selected_texture.hide()
	disabled = false
