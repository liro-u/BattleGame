extends HBoxContainer

onready var sep1 = $VSeparator
onready var sep2 = $VSeparator2

onready var button = $TextureRect/Button
onready var subTitle = $TextureRect/VBoxContainer/MarginContainer/HBoxContainer/SubTitle
onready var title = $TextureRect/VBoxContainer/Title
onready var starContainer = $TextureRect/VBoxContainer/MarginContainer/HBoxContainer/StarContainer

func set_left():
	sep1.size_flags_stretch_ratio = 1
	sep2.size_flags_stretch_ratio = 6

func set_right():
	sep1.size_flags_stretch_ratio = 6
	sep2.size_flags_stretch_ratio = 1

func initialize(lvl):
	button.initialize(lvl)
	var data_level = button.data_level
	if not data_level.unlocked:
		modulate = Color("333333")
	title.text = data_level.level_name
	var children = starContainer.get_children()
	for index in range(0, data_level.task.size()):
		if data_level.task[index]:
			children[index].set_finished(data_level.task[index].finished)
		
