extends Node2D

var generator_data: GeneratorData

var resource_overlay: ResourceOverlay
var path_system: ItemPathSystem

# Called when the node enters the scene tree for the first time.
func _ready():
	for system in get_tree().get_nodes_in_group("system"):
		if system is ItemPathSystem:
			path_system = system
	for overlay in get_tree().get_nodes_in_group("overlay"):
		if overlay is ResourceOverlay:
			resource_overlay = overlay

	GlobalTickSystem.game_tick.connect(_game_tick)


func building_data_updated(building_data: BuildingBase):
	if building_data is GeneratorData:
		generator_data = building_data

func _game_tick():
	resource_overlay.add_power(generator_data.generation_per_tick)
	path_system.create_new_travel_path(resource_overlay.energy_icon,
										AutoDeleteNode.new(5, global_position),
										resource_overlay.power_animation_node,
										generator_data.generation_per_tick, 1
									  )