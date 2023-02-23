extends Control

onready var item_slot_box = $HBoxContainer/ItemBox/ScrollContainer/ItemSlotBox
onready var button_list = $HBoxContainer/Button
onready var pannel_list = [$EquipmentTexture, $ConsumableTexture, $RunesTexture, $MaterialsTexture]
export var category_name = [Category.Category.EQUIPMENT, Category.Category.CONSUMABLE, Category.Category.RUNE, Category.Category.MATERIAL]

func _ready():
	for i in range(button_list.get_child_count()):
		button_list.get_child(i).connect("pressed", self, "load_category", [i])

func initialize():
	load_category(0)
	
func load_category(i):
	move_child(pannel_list[i], 3)
	#reset
	for child in item_slot_box.get_children():
		child.queue_free()
	var begin_path = Global.dataFolderPreset + "://player_data/inventaire"
	var file_list_name = SaverInventory.get_all_file(begin_path)
	var item_slot_instance = load("res://src/GUI/inventaire/itemSlot.tscn")
	for file_name in file_list_name:
		var temp_item = load(begin_path + "/" + file_name)
		if temp_item.things.category == category_name[i]:
			var new_item_slot = item_slot_instance.instance()
			item_slot_box.add_child(new_item_slot)
			new_item_slot.initialize(temp_item)
