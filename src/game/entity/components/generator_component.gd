extends Node2D

var generator_data: GeneratorData

var resource_overlay: ResourceOverlay
var path_system: ItemPathSystem

# Called when the node enters the scene tree for the first time.
func _ready():
	path_system = GlobalDataAccess.get_item_path_system()
	resource_overlay = GlobalDataAccess.get_resource_overlay()

	GlobalTickSystem.game_tick.connect(_game_tick)


func building_data_updated(building_data: BuildingBase):
	if building_data is GeneratorData:
		generator_data = building_data

func _game_tick():
	resource_overlay.add_power(generator_data.generation_per_tick)
	path_system.create_new_travel_path(resource_overlay.energy_icon,
										AutoDeleteNode.new(5, global_position),
										resource_overlay.power_animation_node,
										int(generator_data.generation_per_tick), 1.0
									  )