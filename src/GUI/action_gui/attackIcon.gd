tool
extends TeamIconBattler
class_name AttackIcon

#-------VARIABLES---------#
export(Color) var grey_color = Color("c0000000") setget set_grey_color
export(bool) var disabled = false setget set_disabled
export(int) var mana_cost = 15 setget set_mana_cost
export(int) var turn_needed = 1 setget set_turn_needed
export(DynamicFont) var font_mana  setget set_mana_font
export(DynamicFont) var font_turn  setget set_turn_font
var mana_cost_label
var turn_needed_label
var grey_rect
var button
var attack_node

#------SETGET-------#
#set grey color
func set_grey_color(new_value : Color = grey_color) -> void:
	grey_color = new_value
	grey_rect.self_modulate = grey_color
#set disabled
func set_disabled(new_value: bool = disabled, force: bool = false) -> void:
	if !disabled or force:
		disabled = new_value
		button.disabled = disabled
		if disabled:
			grey_rect.show()
		else:
			grey_rect.hide()
#set back and grey texture
func set_back_texture(new_value : Texture = back_texture) -> void:
	back_texture = new_value
	back.texture = back_texture
	grey_rect.texture = back_texture
#set text label
func set_mana_cost(new_value : int = mana_cost) -> void:
	mana_cost = new_value
	if (get_owner() and get_tree().get_nodes_in_group("turn_queue")[0].active_battler):
		var active_battler = get_tree().get_nodes_in_group("turn_queue")[0].active_battler
		set_disabled(mana_cost > active_battler.stats.mana)
	mana_cost_label.text = str(mana_cost)
func set_turn_needed(new_value : int = turn_needed) -> void:
	turn_needed = new_value
	set_disabled(turn_needed > 0)
	var text = ""
	if turn_needed > 0:
		text = str(turn_needed)
	turn_needed_label.text = text
#set font
func set_mana_font(new_value : DynamicFont = font_mana) -> void:
	font_mana = new_value
	mana_cost_label.set("custom_fonts/font", font_mana)
	mana_cost_label.margin_bottom = - margin_value * 2
	mana_cost_label.margin_right = - margin_value * 2
func set_turn_font(new_value : DynamicFont = font_turn) -> void:
	font_turn = new_value
	turn_needed_label.set("custom_fonts/font", font_turn)
#set nine patch
func set_margin_value(new_value : int = margin_value) -> void:
	margin_value = new_value
	margin_profil.set("custom_constants/margin_right", margin_value)
	margin_profil.set("custom_constants/margin_left", margin_value)
	margin_profil.set("custom_constants/margin_top", margin_value)
	margin_profil.set("custom_constants/margin_bottom", margin_value)
	set_mana_font()

func update_all():
	set_nine_patch_value()
	set_back_color()
	set_border_color()
	set_back_texture()
	set_border_texture()
	set_profil_texture()
	set_margin_value()
	set_keep_ratio()
	set_mana_cost()
	set_grey_color()
	set_turn_needed()
	set_mana_font()
	set_turn_font()
#---------FUNCTIONS------#
#init
func _init() -> void:
	#mana cost
	if mana_cost_label:
		mana_cost_label.queue_free()
	mana_cost_label = Label.new()
	add_child(mana_cost_label)
	mana_cost_label.align = Label.ALIGN_RIGHT
	mana_cost_label.valign = Label.VALIGN_BOTTOM
	mana_cost_label.anchor_bottom = 1
	mana_cost_label.anchor_right = 1
	#turn before avaible
	if grey_rect:
		grey_rect.queue_free()
	grey_rect = TextureRect.new()
	add_child(grey_rect)
	grey_rect.expand = true
	grey_rect.anchor_bottom = 1
	grey_rect.anchor_right = 1
	if turn_needed_label:
		turn_needed_label.queue_free()
	turn_needed_label = Label.new()
	grey_rect.add_child(turn_needed_label)
	turn_needed_label.align = Label.ALIGN_CENTER
	turn_needed_label.valign = Label.ALIGN_CENTER
	turn_needed_label.anchor_bottom = 1
	turn_needed_label.anchor_right = 1
	if button:
		button.queue_free()
	button = Button.new()
	add_child(button)
	button.modulate.a = 0
	button.anchor_right = 1
	button.anchor_bottom = 1
	button.connect("pressed", self, "pressed")

#ready
func _ready() -> void:
	initialize()

#init
func initialize() -> void:
	update_all()

func setup_from_attack(attack : Attack = null):
	disabled = false
	if attack != null:
		attack_node = attack
		set_mana_cost(attack.mana_cost)
		set_turn_needed(attack.actual_turn)
		set_profil_texture(attack.base_attack_data.icon)
		match attack.element:
			Element.Element.NONE:
				set_border_color(Color("bbbbbb"))
				set_back_color(Color("91bdd4"))
			Element.Element.AIR:
				set_border_color(Color("ffffff"))
				set_back_color(Color("91fdd4"))
			Element.Element.EARTH:
				set_border_color(Color("563620"))
				set_back_color(Color("b57a51"))
			Element.Element.FIRE:
				set_border_color(Color("fb0505"))
				set_back_color(Color("960c0c"))
			Element.Element.WATER:
				set_border_color(Color("00ffe7"))
				set_back_color(Color("07b89f"))
	else:
		attack_node = null

func pressed() -> void:
	get_tree().get_nodes_in_group("action_gui")[0].disabled_all_button()
	attack_node.ask_use_attack()

func desactivate(Bool : bool = true):
	if Bool:
		button.disabled = false
	else:
		button.disabled = disabled
