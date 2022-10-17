extends TextureButton

export(String) var tag
signal filter_by_pressed

func _ready():
	connect("pressed", self, "emit_signal", ["filter_by_pressed", tag, self])

