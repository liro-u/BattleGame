extends TextureRect

onready var description = $MarginContainer/VBoxContainer/HBoxContainer/Description
onready var data_bonus = $MarginContainer/VBoxContainer/HBoxContainer/Data
onready var reward_data = $MarginContainer/VBoxContainer/HBoxContainer2/Reward/RewardData
onready var reward_texture = $MarginContainer/VBoxContainer/HBoxContainer2/Reward/RewardTexture
onready var button = $MarginContainer/VBoxContainer/HBoxContainer2/VBoxContainer/Button

var task 

export var color_finished = Color("5d5d5d")
	
func initialize(data):
	task = data
	description.text = task.description
	reward_data.text = "x " + str(task.reward.quantity)
	reward_texture.texture = task.reward.things.texture
	if task.finished:
		modulate = color_finished
		button.disabled = true
		
	
	
