extends AnimationTree

signal end()

func finished():
	emit_signal("end")
