extends Node

@export var game_scene: PackedScene

func _unhandled_input(event):
	if event.is_action("restart_game") and Input.is_action_pressed("restart_game"):
		get_tree().reload_current_scene()
		