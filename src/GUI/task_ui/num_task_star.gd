extends VBoxContainer

onready var label = $Label
onready var valideStar = $StarBack/ValidateStar

var nb_star = 0

func initialize(n):
	label.text = str(n)
	nb_star = n

func validate_task():
	valideStar.show()

