extends TextureRect

var chapter_data
export var chapitre = ""

onready var butt = $Button
onready var title_label = $MarginContainer/HBoxContainer/Title
onready var subTitle = $MarginContainer/HBoxContainer/ScrollContainer

signal is_clicked

func initialize(data):
	chapter_data = data
	title_label.text = chapter_data.chapterName + " :"
	if not chapter_data.unlocked:
		disabled()
	subTitle.initialize(chapter_data.sub_title)
		
func set_active(b = true):
	if b:
		modulate = Color("ffffff")
		butt.disabled = true
		add_to_group("active_chapter_button_selector")
	else:
		modulate = Color("b2a2bee4")
		butt.disabled = false
		if is_in_group("active_chapter_button_selector"):
			remove_from_group("active_chapter_button_selector")

func disabled():
	modulate = Color("333333")
	butt.disabled = true

func is_pressed():
	get_tree().call_group_flags(get_tree().GROUP_CALL_REALTIME, "active_chapter_button_selector", "set_active", false)
	set_active()
	emit_signal("is_clicked", chapitre)
