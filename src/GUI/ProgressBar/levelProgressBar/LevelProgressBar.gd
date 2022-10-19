extends Control

onready var name_value_label = $"Data/VBoxContainer/NameValue"
onready var value_label = $"Data/VBoxContainer/Value"
onready var data = $Data
onready var progressBar = $"ProgressBar"

export var show_data = true
export var show_name_value = true

func _ready():
	data.visible = show_data
	name_value_label.visible = show_name_value
	_on_LevelProgressBar_resized()
	
func set_progress(new_value):
	progressBar.value = min(999, new_value)

func set_value(new_value):
	value_label.text = str(new_value)



func _on_LevelProgressBar_resized():
	if progressBar:
		progressBar.rect_min_size = rect_size
