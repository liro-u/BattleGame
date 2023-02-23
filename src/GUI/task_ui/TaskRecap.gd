extends TextureRect

onready var description_auto_scroll = $"MarginContainer/VBoxContainer/AutoScroll"
onready var data_bonus = $MarginContainer/VBoxContainer/AutoScroll/HBoxContainer/Data
onready var reward_data = $MarginContainer/VBoxContainer/HBoxContainer2/Reward/RewardData
onready var reward_texture = $MarginContainer/VBoxContainer/HBoxContainer2/Reward/RewardTexture
onready var button = $MarginContainer/VBoxContainer/HBoxContainer2/VBoxContainer/Button

var task 

export var color_finished = Color("5d5d5d")

signal save_task

func initialize(data):
	task = data
	description_auto_scroll.initialize(task.description)
	if (task.reward != null):
		reward_data.text = "x " + str(task.reward.quantity)
		reward_texture.texture = task.reward.things.texture
	else:
		reward_data.text = ""
		reward_texture.texture = null
	if task.finished:
		button.text = "claim"
	if task.claimed:
		disabled_task()
		
func disabled_task():
	modulate = color_finished
	button.disabled = true
	button.text = "finished"

func _on_Button_pressed():
	if task.finished:
		task.claimed = true
		SaverInventory.addNewThings(task.reward)
		emit_signal("save_task")
		disabled_task()
	else:
		print("redirection vers une page")
