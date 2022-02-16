tool
extends Control
class_name TurnLine

#---------VARIABLES-----------#
#preset
export(int) var nbr_case = 0 setget set_nbr_case
export(Vector2) var adding_pos = Vector2(-70, 0) setget set_adding_pos
export(int) var space_border = 100 setget set_space_border
export(Vector2) var size_icon = Vector2(140, 140) setget set_size_icon
export(Vector2) var scale_value = Vector2(0.3, 0.3) setget set_scale_value
export(Curve) var curve_move = Curve.new()
export(Curve) var curve_alpha = Curve.new()
export(Vector2) var spawn_point = Vector2.ZERO
export(float) var time_tween = 0.5
export(float) var time_tween_spawn = 1.5
export(float) var mult_alpha_speed = 0.7
var time_tween_value = time_tween_spawn
#default case
export(Texture) var default_profile_texture = load("res://asset/chararacters/001_testChar/icon.png")
export(Color) var enemy_border_color = Color.red
export(Color) var enemy_back_color = Color("8c0000")
export(Color) var  player_border_color= Color("0d1783")
export(Color) var  player_back_color= Color("2d5399")
#icon
export(int) var ninepatch_value = 27
export(int) var margin_value = 3
#loaded node path
onready var arrow = $arrow
onready var line = $line
#other var
var list_case : Array = []
#---------SETGET-------------#
func set_nbr_case(new_value : int = nbr_case) -> void:
	if line and new_value >= 0:
		while list_case.size() != new_value:
			if list_case.size() < new_value:
				add_case()
			else:
				del_case()
func set_adding_pos(new_value : Vector2 = adding_pos) -> void:
	adding_pos = new_value
	update_position()
	update_self_size()
func set_space_border(new_value : int = space_border) -> void:
	space_border = new_value
	update_position()
func set_size_icon(new_value : Vector2 = size_icon) -> void:
	size_icon = new_value
	for case in list_case:
		case.rect_size = size_icon
	update_position()
	update_self_size()
func set_scale_value(new_value : Vector2 = scale_value) -> void:
	if line and arrow:
		scale_value = new_value
		arrow.rect_scale = scale_value
		line.rect_scale = scale_value
		update_self_size()
#-----------FUNCTIONS----------#
func _ready() -> void:
	update_self_size()
	time_tween_value = time_tween

func update_self_size() -> void:
	if line and arrow:
		rect_size.x = line.rect_size.x
		rect_size.y = max(max(arrow.rect_size.y, line.rect_size.y), size_icon.y)
		rect_size *= scale_value
		arrow.rect_position.y = (-adding_pos.y + size_icon.y / 2) * scale_value.y
		line.rect_position.y = (-adding_pos.y + size_icon.y / 2) * scale_value.y

func add_case(team : int = 0) -> void:
	nbr_case += 1
	var new_case : TweenTeamIconBattler = TweenTeamIconBattler.new()
	line.add_child(new_case)
	list_case.append(new_case)
	new_case.nine_patch_value = ninepatch_value
	new_case.margin_value = margin_value
	new_case.rect_size = size_icon
	var back_color
	var border_color
	if team == 0:
		back_color = player_back_color
		border_color = player_border_color
	else:
		back_color = enemy_back_color
		border_color = enemy_border_color
	new_case.border_color = border_color
	new_case.back_color = back_color
	new_case.tween_move.curve = curve_move
	new_case.tween_alpha.curve = curve_alpha
	new_case.rect_position.x = spawn_point.x
	new_case.rect_position.y = spawn_point.y - size_icon.y / 2 + adding_pos.y
	new_case.appear(time_tween_value * mult_alpha_speed)
	update_position()

func del_case() -> void:
	del_case_pos(0)
		
func del_case_pos(n = list_case.size() - 1) -> void:
	if list_case.size() > 0 and n >= 0 and n < list_case.size():
		nbr_case -= 1
		list_case[n].delete(time_tween_value * mult_alpha_speed)
		list_case.remove(n)
		update_position()

func update_position() -> void:
	for i in range (1, list_case.size() + 1):
		list_case[i - 1].tween_move.play(time_tween_value, list_case[i - 1].rect_position,  calcul_position(i))

func calcul_position(n : int = 1) -> Vector2:
	var pos : Vector2 = Vector2.ZERO
	var space_between_case = (line.rect_size.x - space_border) / (nbr_case + 1)
	pos.x = space_between_case * n + space_border / 2 + adding_pos.x
	pos.y = adding_pos.y - size_icon.y / 2
	return pos
