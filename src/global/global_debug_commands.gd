extends Node

func _ready():
	Console.register_custom_command("clear_enemies", _clear_all_enemies, [], "Kill all the enemies on the map")
	Console.register_custom_command("repair_buildings", _repair_all_buildings, [], "Repair all the player buildings on the map")
	Console.register_custom_command("damage_buildings", _damage_all_buildings, ["(float) percentage to damage"], "Damage all the player buildings on the map by a percentage of their max hp", "", ["damage_buildings 0.5"])

func _exit_tree():
	Console.remove_command("clear_enemies")

func _clear_all_enemies() -> String:
	var count = 0
	for enemy in get_tree().get_nodes_in_group("enemy"):
		enemy.queue_free()
		count += 1
	
	return "Removed %s enemies" % count

func _repair_all_buildings() -> String:
	var count = 0
	var return_data = ""
	for building in get_tree().get_nodes_in_group("building"):
		if building is Building:
			var repair_points = building.stats.hp - building.stats.max_hp
			return_data += "%s: %s\n" % [building.name, repair_points]
			if repair_points > 0:
				count += 1
			building.deal_damage(repair_points, 0)
	
	return_data += "Repaired %s buildings\n" % count
	return return_data


func _damage_all_buildings(percentage: String) -> String:
	if !percentage.is_valid_float():
		return "[color=red]Invalid percentage value[/color]"
	var count = 0
	var return_data = ""
	for building in get_tree().get_nodes_in_group("building"):
		if building is Building:
			var real_percentage = float(percentage)
			real_percentage = clampf(real_percentage, 0.0, 1.0)
			var damage = building.stats.max_hp * real_percentage
			building.deal_damage(damage, 0)
			return_data += "%s: %s\n" % [building.name, damage]
			count += 1

	return return_data + "Damaged %s buildings\n" % count