extends Button
export var level = 1
export(NodePath) var level_select_path
var level_select
var chapitre

var data_level

func _ready():
	level_select = get_node(level_select_path)
	chapitre = level_select.chapitre
	data_level = load(Global.dataFolderPreset + "://player_data/level_data/chapitre_" + str(chapitre) + "/level_" + str(level) + "/data.tres")
	initialize()
	connect("pressed", level_select, "select_level", [level, data_level])

func initialize():
	disabled = not data_level.unlocked
		
