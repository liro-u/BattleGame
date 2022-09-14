extends TextureButton

export(int) var element
signal element_pressed

func _ready():
	connect("pressed", self, "emit_signal", ["element_pressed", element, self])
