extends Node

var _resource_overlay: ResourceOverlay
var _phase_manager: GameStateManager


func get_resource_overlay() -> ResourceOverlay:
	return _resource_overlay

func get_phase_manager() -> GameStateManager:
	return _phase_manager

func game_started():
	for overlay in get_tree().get_nodes_in_group("overlay"):
		if overlay is ResourceOverlay:
			_resource_overlay = overlay

	for system in get_tree().get_nodes_in_group("system"):
		if system is GameStateManager:
			_phase_manager = system

func game_stopped():
	_resource_overlay = null
	_phase_manager = null