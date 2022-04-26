tool
extends Control
class_name TurnLine

#---------VARIABLES-----------#
#preset
export(Texture) var texture_arrow = load("res://asset/GUI/turnline/arrow.png") setget set_texture_arrow
export(Texture) var texture_line = load("res://asset/GUI/turnline/line.png") setget set_texture_line
export(Vector2) var line_start_pos = Vector2(0, 17) setget set_line_start_pos
export(int) var max_nbr_case = 6
export(int) var nbr_case = 0 setget set_nbr_case
export(Vector2) var adding_pos = Vector2(-70, 15) setget set_adding_pos
export(int) var space_border = 100 setget set_space_border
export(Vector2) var size_icon = Vector2(200, 200) setget set_size_icon
export(Vector2) var scale_value = Vector2(0.3, 0.3) setget set_scale_value
export(Curve) var curve_move = Curve.new() setget set_curve_move
export(Curve) var curve_alpha = Curve.new() setget set_curve_alpha
export(Vector2) var spawn_point = Vector2(2000, 0) #no setget needed
export(float) var time_tween = 0.5 setget set_time_tween
export(float) var time_tween_spawn = 1.5 #no setget needed
export(float) var mult_alpha_speed = 0.7 #no setget needed
var time_tween_value = time_tween_spawn
#default case
export(Texture) var default_profile_texture = load("res://asset/chararacters/001_testChar/icon.png") #no setget needed
export(Color) var enemy_border_color = Color.red #no setget needed
export(Color) var enemy_back_color = Color("8c0000") #no setget needed
export(Color) var  player_border_color= Color("0d1783") #no setget needed
export(Color) var  player_back_color= Color("2d5399") #no setget needed
#icon
export(int) var ninepatch_value = 27 #no setget needed
export(int) var margin_value = 3 #no setget needed
#loaded node path
var arrow
var line
#other var
var list_case : Array = []

#---------SETGET-------------#
#set texture
func set_texture_arrow(new_value : Texture = texture_arrow) -> void:
	texture_arrow = new_value
	arrow.texture = texture_arrow
func set_texture_line(new_value : Texture = texture_line) -> void:
	texture_line = new_value
	line.texture = texture_line

#update case
func set_nbr_case(new_value : int = nbr_case) -> void:
	if line and new_value >= 0:
		while list_case.size() != new_value:
			if list_case.size() < new_value:
				add_case()
			else:
				del_case()

#position calculation
func set_line_start_pos(new_value : Vector2 = line_start_pos) -> void:
	line_start_pos = new_value
	update_self_size()
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
func set_time_tween(new_value : float = time_tween) -> void:
	time_tween = new_value
	time_tween_value = time_tween
func refresh_pos() -> void:
	set_line_start_pos()
	set_adding_pos()
	set_space_border()
	set_size_icon()
	set_scale_value()
	set_time_tween()

#curve
func set_curve_move(new_value : Curve = curve_move) -> void:
	curve_move = new_value
	for i in range (1, list_case.size() + 1):
		list_case[i - 1].tween_move.curve = curve_move
func set_curve_alpha(new_value : Curve = curve_alpha) -> void:
	curve_alpha = new_value
	for i in range (1, list_case.size() + 1):
		list_case[i - 1].tween_alpha.curve = curve_alpha
	
#-----------FUNCTIONS----------#
#init
func _init():
	if arrow:
		arrow.queue_free()
	arrow = TextureRect.new()
	add_child(arrow)
	arrow.stretch_mode = 6
	if line:
		line.queue_free()
	line = TextureRect.new()
	add_child(line)
	line.stretch_mode = 6
	

#ready
func _ready() -> void:
	set_texture_arrow()
	set_texture_line()
	refresh_pos()
	time_tween_value = time_tween

#init
func initialise(children : Array, active_battler : int = 0) -> void:
	var info_battler_turnline = []
	var i = active_battler
	if children.size() > 0:
		while i < max_nbr_case + active_battler :
			var child = children[i % children.size()]
			info_battler_turnline.append([child.team, child.startingStats.icon])
			i += 1
	del_all_case()
	add_case_by_list(info_battler_turnline)

#position calculation
func update_self_size() -> void:
	if line and arrow:
		rect_size.x = line.rect_size.x
		rect_size.y = max(max(arrow.rect_size.y, line.rect_size.y), size_icon.y)
		rect_size *= scale_value
		arrow.rect_position.y = (-adding_pos.y + size_icon.y / 2) * scale_value.y
		line.rect_position.y = (-adding_pos.y + size_icon.y / 2 + line_start_pos.y) * scale_value.y
func update_position() -> void:
	for i in range (1, list_case.size() + 1):
		list_case[i - 1].tween_move.play(time_tween_value, list_case[i - 1].rect_position,  calcul_position(i))
func calcul_position(n : int = 1) -> Vector2:
	var pos : Vector2 = Vector2.ZERO
	var space_between_case = (line.rect_size.x - space_border) / (nbr_case + 1)
	pos.x = space_between_case * n + space_border / 2 + adding_pos.x
	pos.y = adding_pos.y - size_icon.y / 2
	return pos

#manage case
func add_case_by_list(list : Array) -> void:
	for battler_data in list:
		add_case(battler_data[0], battler_data[1])
func add_case(team : int = 0, icon : Texture = default_profile_texture) -> void:
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
	new_case.profil_texture = icon
	new_case.tween_move.curve = curve_move
	new_case.tween_alpha.curve = curve_alpha
	new_case.rect_position.x = spawn_point.x
	new_case.rect_position.y = spawn_point.y - size_icon.y / 2 + adding_pos.y
	new_case.appear(time_tween_value * mult_alpha_speed)
	update_position()
func replace_case_by(team : int = 0, icon : Texture = default_profile_texture) -> void:
	del_case()
	add_case(team, icon)
func replace_case_by_list(list : Array) -> void:
	for battler_data in list:
		replace_case_by(battler_data[0], battler_data[1])
func del_case(anim : bool = true) -> void:
	del_case_pos(0, anim)
func del_case_pos(n = list_case.size() - 1, anim : bool = true) -> void:
	if list_case.size() > 0 and n >= 0 and n < list_case.size():
		nbr_case -= 1
		if anim:
			list_case[n].delete(time_tween_value * mult_alpha_speed)
		else:
			list_case[n].queue_free()
		list_case.remove(n)
		update_position()
func del_all_case() -> void:
	while list_case.size() > 0:
		del_case(false)
