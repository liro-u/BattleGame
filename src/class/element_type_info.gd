extends Node
class_name ElementTypeInfo

const element_color = {
	0:Color(0,0,0),
	1:Color("ffc981"),
	2:Color("5c7ccf"),
	3:Color("a5fff9"),
	4:Color("bd4f38"),
}

static func get_type_texture(type):
	if type == Type.Type.DPS:
		return load("res://asset/GUI/chara_select/dps.png")
	elif type == Type.Type.SUPPORT:
		return load("res://asset/GUI/chara_select/support.png")
	else:
		return load("res://asset/GUI/chara_select/tank.png")
