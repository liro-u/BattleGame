extends Node
class_name ElementCalculation

const num_to_element = {
	0 : "NONE",
	1 : "EARTH",
	2 : "WATER",
	3 : "AIR",
	4 : "FIRE",
}

static func element_calculation(att, def):
	var file = File.new()
	var tab = []
	var csv_path = "res://asset/Element/element.dat"
	if file.open(csv_path, file.READ) == OK:
		while !file.eof_reached():
			var row = file.get_csv_line("	")
			tab.append(row)
		file.close()
	var idx1 = -1
	for i in tab[0]:
		idx1 += 1
		if i == num_to_element[att]:
			break
	for i in tab:
		if i[0] == num_to_element[def]:
			return i[idx1]
			break
	return 1
