extends Node
class_name levelCalculation
	
static func add_xp(xp_gain, battler_data):
	var level = battler_data.level
	var xp = battler_data.xp + xp_gain
	var starting_xp = battler_data.stats_reference.starting_xp_needed
	var level_palier = battler_data.stats_reference.level_palier
	var xp_needed = xp_needed_for_level(level, starting_xp, level_palier)
	while xp > xp_needed:
		level += 1
		xp -= xp_needed
		xp_needed = xp_needed_for_level(level, starting_xp, level_palier)
	battler_data.level = level
	battler_data.xp = xp
	return battler_data

static func xp_needed_for_level(level, starting_xp, level_palier):
	var actual_level = 1
	var xp_needed = starting_xp
	var key_list = level_palier.keys()
	key_list.sort()
	var actual_key = 0
	while actual_level != level:
		actual_level += 1
		#verif if there is bigger level palier
		if key_list.size() > (actual_key + 1):
			#verif if actual level is bigger or equal to next level palier
			if key_list[actual_key + 1] <= actual_level:
				actual_key += 1
		xp_needed += level_palier[key_list[actual_key]]
	return xp_needed
		
		
