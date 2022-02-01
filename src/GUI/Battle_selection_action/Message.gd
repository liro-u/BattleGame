extends VBoxContainer

onready var message = $Message
onready var message2 = $Message2

func set_text(array):
	var nb = 0
	for text in array:
		if nb < get_child_count():
			get_child(nb).text = text
			nb += 1
	while nb < get_child_count():
		get_child(nb).text = ""
		nb += 1
