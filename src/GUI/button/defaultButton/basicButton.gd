tool
extends Button

onready var texture = $Texture
onready var label = $VBoxContainer/Label

export var background_color : Color

func _initialize():
	label.text = text
	if disabled:
		set_texture("disabled")
	else:
		set_texture("normal")

func _on_Button_button_up():
	set_texture("normal")

func _on_Button_button_down():
	set_texture("pressed")
	
func set_texture(state):
	match state:
		"pressed":
			texture.modulate = background_color * 0.7
			texture.modulate.a = 1
		"normal":
			texture.modulate = background_color
			modulate.a = 1
		"disabled":
			texture.modulate = background_color
			modulate.a = 0.5
