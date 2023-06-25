extends TextureRect

func set_finished(is_finished):
	if is_finished:
		texture = load("res://asset/GUI/quest_asset/star_full.png")
	else:
		texture = load("res://asset/GUI/quest_asset/star_empty.png")
