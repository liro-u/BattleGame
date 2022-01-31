tool
extends HBoxContainer

signal button_pressed(nb)

func initialize(attack_list):
	var nb_attack = 0
	for attack in attack_list:
		if nb_attack < get_child_count():
			nb_attack = init_child(nb_attack, attack)
	while nb_attack < get_child_count():
		nb_attack = init_child(nb_attack)
		
func init_child(nb, attack = null):
	var child = get_child(nb)
	child.attack = attack
	child.initialize()
	return nb + 1

func button_pressed(nb):
	emit_signal("button_pressed", nb)
