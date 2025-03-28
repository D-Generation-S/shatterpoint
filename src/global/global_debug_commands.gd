extends Node

func _ready():
	Console.register_custom_command("clear_enemies", _clear_all_enemies, [], "Kill all the enemies on the map")

func _exit_tree():
	Console.remove_command("clear_enemies")

func _clear_all_enemies() -> String:
	var count = 0
	for enemy in get_tree().get_nodes_in_group("enemy"):
		enemy.queue_free()
		count += 1
	
	return "Removed %s enemies" % count
