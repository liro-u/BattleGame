tool
extends TextureButton
class_name ui_cancel

var is_hide = false

func _ready():
	initialize()
	
func initialize() -> void:
	shortcut = ShortCut.new()
	shortcut.shortcut = InputEventAction.new()
	shortcut.shortcut.action = 'ui_cancel'
	connect("pressed", self, "cancel_is_pressed")
	add_to_group("ui_cancel")

func cancel_is_pressed():
	pass

func desactivate():
	disabled = true

func activate():
	disabled = false

func disappear():
	if ! is_hide:
		is_hide = true
		hide()

func appear():
	if is_hide:
		is_hide = false
		show()


