tool
extends TweenProgressBar
class_name MultiProgressBar

#-----------VARIABLES------------#
#multi bar
export(int, 1, 99) var nb_bar = 1 setget set_nb_bar
export(Array, Color) var list_color = [Color.mediumspringgreen, Color.lightseagreen, Color.orange, Color.blueviolet] setget set_list_color
export(bool) var show_nb_bar = true setget set_show_nb_bar
export(float) var separation = 10 setget set_separation
#theme
export(DynamicFont) var custom_font_nb_bar_label setget set_custom_font_nb_bar_label
#bar var
var list_bar : Array = [self]
var active_bar = self
#loaded node path
var nb_bar_label : Label

#---------SETGET-----------#
func set_show_nb_bar(new_value : bool = show_nb_bar) -> void:
	show_nb_bar = new_value
	if nb_bar_label:
		if show_nb_bar:
			nb_bar_label.show()
		else:
			nb_bar_label.hide()
		
func set_nb_bar(new_value : int = nb_bar) -> void:
	while list_bar.size() != new_value:
		if list_bar.size() < new_value:
			add_bar()
		else:
			delete_bar()

func set_separation(new_value : float = separation) -> void:
	separation = new_value
	set_min_rect_size()

func set_custom_font_nb_bar_label(new_value : DynamicFont = custom_font_nb_bar_label) -> void:
	custom_font_nb_bar_label = new_value
	nb_bar_label.set("custom_fonts/font", custom_font_nb_bar_label)
	update_nb_bar_label()

func set_list_color(new_value : Array = list_color):
	list_color = new_value
	for i in range(0, list_bar.size()):
		list_bar[i].set("direct_color", list_color[i % list_color.size()])


func update_multi_bar_export():
	set_list_color()
	set_custom_font_nb_bar_label()
	set_separation()
	set_show_nb_bar()
	set_nb_bar()

#-----------FUNCTION---------#
#init
func _init() -> void:
	for child in list_bar:
		if child != self:
			child.queue_free()
	if nb_bar_label:
		nb_bar_label.queue_free()
	nb_bar_label = Label.new()
	add_child(nb_bar_label)
	nb_bar_label.theme = custom_theme


#ready
func _ready() -> void:
	init_mult()
#init direct_color
func init_mult() -> void:
	update_multi_bar_export()
	update_nb_bar_label()

#update nb bar label
func update_nb_bar_label(new_value : int = nb_bar) -> void:
	if nb_bar_label:
		if new_value > 1:
			nb_bar_label.text = "X " + str(new_value)
			nb_bar_label.hide()
			nb_bar_label.show()
			nb_bar_label.anchor_left = 1
			nb_bar_label.anchor_top = 0.5
			nb_bar_label.anchor_right = 1
			nb_bar_label.anchor_bottom = 0.5
			nb_bar_label.margin_left = -nb_bar_label.rect_size.x
			nb_bar_label.margin_top = -nb_bar_label.rect_size.y / 2
			nb_bar_label.margin_bottom = nb_bar_label.rect_size.y / 2
		else:
			nb_bar_label.hide()
		set_min_rect_size()

#delete bar
func delete_bar(rest_value : int = 0) -> void:
	if list_bar.size() > 1:
		nb_bar -= 1
		update_nb_bar_label()
		var last_show_value : bool = active_bar.show_value
		active_bar.queue_free()
		list_bar.remove(list_bar.size() - 1)
		active_bar = list_bar[list_bar.size() - 1]
		active_bar.set("null_over_texture", false)
		active_bar.set("show_value", last_show_value)
		active_bar.update_value(active_bar.current_value + rest_value)
#add bar
func add_bar(max_value : int = start_value) -> void:
	nb_bar += 1
	update_nb_bar_label()
	var new_bar : TweenProgressBar = TweenProgressBar.new()
	add_child(new_bar)
	list_bar.append(new_bar)
	#set data bar
	sync_data(new_bar)
	new_bar.initialize(max_value)
	active_bar.set("null_over_texture", true)
	active_bar.set("show_value", false)
	new_bar.set("null_under_texture", true)
	new_bar.set("direct_color", list_color[(list_bar.size() - 1)%list_color.size()])
	new_bar.connect("bar_is_empty", self, "delete_bar")
	active_bar = new_bar
#sync data
func sync_data(node : TweenProgressBar) -> void:
	node.set("show_value", active_bar.show_value)
	node.set("up_color", active_bar.up_color)
	node.set("down_color", active_bar.down_color)
	node.set("basic_under_texture", active_bar.basic_under_texture)
	node.set("basic_over_texture", active_bar.basic_over_texture)
	node.set("basic_progress_texture", active_bar.basic_progress_texture)
	node.set("null_progress_texture", active_bar.null_progress_texture)
	node.set("size_rect", active_bar.size_rect)
	node.set("scale_rect", active_bar.scale_rect)
	node.set("stretch_margin_left", active_bar.stretch_margin_left)
	node.set("stretch_margin_right", active_bar.stretch_margin_right)
	node.set("stretch_margin_top", active_bar.stretch_margin_top)
	node.set("stretch_margin_bottom", active_bar.stretch_margin_bottom)
	node.set("nine_patch_stretch", active_bar.nine_patch_stretch)
	node.set("custom_theme", null)
	node.set("alpha_curve", active_bar.alpha_curve)
	node.set("value_curve", active_bar.value_curve)
	node.set("custom_font_progress_value", custom_font_progress_value)
	node.set("custom_font_color_progress_value", custom_font_color_progress_value)

#-----------MODIFIED FUNCTION-----------#
#update value
func update_value(new_value : int) -> void:
	if active_bar.current_value != new_value:
		if active_bar == self:
			if current_value > new_value:
				set_down_mode(true)
				alpha_tween.play(1, 0.8, 0.35)
			else:
				alpha_tween.remove_all()
				set_down_mode(false)
			calcul_value(new_value)
			direct_progress_bar.value = new_value
			value_tween.play(1, tween_progress_bar.value, current_value)
		else:
			active_bar.update_value(new_value)

#set value
func set_value(new_value : int) -> void:
	if active_bar.current_value != new_value:
		if active_bar == self:
			calcul_value(new_value)
			value_tween.remove_all()
			alpha_tween.remove_all()
			tween_progress_bar.tint_progress.a = 0
			tween_progress_bar.value = current_value
			direct_progress_bar.value = current_value
			update_value_label(current_value)
		else:
			active_bar.set_value(new_value)

func update_first_value(new_value : int) -> void:
		if current_value > new_value:
			set_down_mode(true)
			alpha_tween.play(1, 0.8, 0.35)
		else:
			alpha_tween.remove_all()
			set_down_mode(false)
		calcul_value(new_value)
		direct_progress_bar.value = new_value
		value_tween.play(1, tween_progress_bar.value, current_value)

#show value
func set_show_value(new_value : bool = show_value) -> void:
	if active_bar:
		show_value = new_value
		if active_bar == self:
			if show_value:
				value_label.show()
			else:
				value_label.hide()
		else:
			active_bar.set("show_value", new_value)
#set min rect size
func set_min_rect_size() -> void:
	rect_min_size = size_rect * scale_rect
	if nb_bar_label:
		rect_min_size.x += nb_bar_label.rect_size.x + separation
		rect_min_size.y = max(rect_min_size.y, nb_bar_label.rect_size.y)
	rect_size = rect_min_size
#update size
func update_size() -> void:
	set_size_rect()
	set_scale_rect()
	set_separation()
