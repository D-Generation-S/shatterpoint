extends Node

var _resource_overlay: ResourceOverlay
var _phase_manager: GameStateManager
var _item_path_system: ItemPathSystem
var _message_area: MessageArea
var _popup_manager: PopupManager


func get_resource_overlay() -> ResourceOverlay:
	return _resource_overlay

func get_phase_manager() -> GameStateManager:
	return _phase_manager

func get_item_path_system() -> ItemPathSystem:
	return _item_path_system

func get_message_area() -> MessageArea:
	return _message_area

func get_popup_manager() -> PopupManager:
	return _popup_manager

func game_started():
	for overlay in get_tree().get_nodes_in_group("overlay"):
		if overlay is ResourceOverlay:
			_resource_overlay = overlay
		if overlay is MessageArea:
			_message_area = overlay
		if overlay is PopupManager:
			_popup_manager = overlay

	for system in get_tree().get_nodes_in_group("system"):
		if system is GameStateManager:
			_phase_manager = system
		if system is ItemPathSystem:
			_item_path_system = system

func game_stopped():
	_resource_overlay = null
	_phase_manager = null
	_item_path_system = null