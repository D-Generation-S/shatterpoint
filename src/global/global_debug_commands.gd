extends Node

@export var effects: Array[DebugEffect]

func _ready():
	Console.register_custom_command("clear_enemies", _clear_all_enemies, [], "Kill all the enemies on the map")
	Console.register_custom_command("repair_buildings", _repair_all_buildings, [], "Repair all the player buildings on the map")
	Console.register_custom_command("damage_buildings", _damage_all_buildings, ["(float) percentage to damage"], "Damage all the player buildings on the map by a percentage of their max hp", "", ["damage_buildings 0.5"])
	if effects.size() > 0:
		Console.register_custom_command("list_effects", _list_all_effects, [], "List all the possible effect")
		Console.register_custom_command("spawn_effect", _spawn_effect, ["(float) x position", "(float) y position", "effect name"], "Spawn a given effect at the given position")

func _exit_tree():
	Console.remove_command("clear_enemies")
	Console.remove_command("repair_buildings")
	Console.remove_command("damage_buildings")
	Console.remove_command("list_effects")
	Console.remove_command("spawn_effect")


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

func _list_all_effects() -> String:
	var return_data = ""
	for effect in effects:
		return_data += "- %s" % effect.name
	return return_data

func _spawn_effect(pos_x: String, pos_y: String, effect_name: String) -> String:
	if !pos_x.is_valid_float():
		return "[color=red]X position is not a valid float[/color]"
	if !pos_y.is_valid_float():
		return "[color=red]Y position is not a valid float[/color]"
	var matching_effects = effects.filter(func(current_effect): return current_effect.name == effect_name)
	if matching_effects.size() == 0:
		return "[color=red]Effect with name %s was not found[/color]" % effect_name
	if matching_effects.size() > 1:
		return "[color=red]Effect with name %s was found multiple times[/color]" % effect_name

	var x_pos_float = float(pos_x)
	var y_pos_float = float(pos_y)
	var instance = effects[0].scene.instantiate() as Node2D
	instance.global_position = Vector2(x_pos_float, y_pos_float)
	add_child(instance)
	return "Added effect %s at position %s/%s" % [effect_name, pos_x, pos_y]