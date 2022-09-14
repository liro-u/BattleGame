extends TextureButton

export(int) var type
signal type_pressed

func _ready():
	connect("pressed", self, "emit_signal", ["type_pressed", type, self])
