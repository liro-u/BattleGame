extends Button
export var level = 1
var level_select
var chapitre

var data_level

func _ready():
	level_select = get_tree().get_nodes_in_group("level_selector_node")[0]
	chapitre = level_select.chapitre

func initialize(lvl):
	level = int(lvl)
	data_level = load(Global.dataFolderPreset + "://player_data/level_data/story/chapitre_" + str(chapitre) + "/level_" + str(level) + "/data.tres")
	disabled = not data_level.unlocked
	connect("pressed", level_select, "select_level", [level, data_level])
		
