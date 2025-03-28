extends Node

@export var game_scene: PackedScene

func _ready():
	Console.register_custom_command("reload", _reload_scene, [], "Reload the game scene")

func _unhandled_input(event):
	if event.is_action("restart_game") and Input.is_action_pressed("restart_game"):
		GlobalDataAccess.game_stopped()
		_reload_scene()
		
func _reload_scene():
	get_tree().reload_current_scene()
