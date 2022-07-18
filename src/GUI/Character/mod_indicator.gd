extends TextureRect

onready var turn_label = $TurnLabel
var turn = -999

func _ready():
	rect_min_size = Vector2(80, 80)
	rect_size = Vector2(80, 80)
	update_turn(turn)
	
func update_turn(new_turn):
	if new_turn <= 0:
		turn_label.hide()
	else:
		turn_label.text = str(new_turn)
