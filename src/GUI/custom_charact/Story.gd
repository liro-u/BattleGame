extends TextureRect

onready var genre_node = $Content/MarginContainer/ScrollContainer/VBoxContainer/Genre/Value
onready var age_node = $Content/MarginContainer/ScrollContainer/VBoxContainer/Age/Value
onready var lieu_naissance_node = $Content/MarginContainer/ScrollContainer/VBoxContainer/LieuDeNaissance/Value
onready var temperament_node = $Content/MarginContainer/ScrollContainer/VBoxContainer/Temperament/Value
onready var origine_node = $Content/MarginContainer/ScrollContainer/VBoxContainer/Origine/Value

func initialize(data):
	genre_node.text = data.genre
	age_node.text = data.age
	lieu_naissance_node.text = data.lieu_naissance
	temperament_node.text = data.temperament
	origine_node.text = data.histoire
