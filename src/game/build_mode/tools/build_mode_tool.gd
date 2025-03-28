class_name BuildModeTool extends Resource

@export var validators: Array[BuildValidator] = []
@export var use_build_entry_icon_as_ghost: bool = true
@export var ghost_icon: Texture = null
# This value can be null, this is only required of this should really build something
@export var building_data: BuildingBase = null

func can_be_used(tree: SceneTree, building: Building, global_position: Vector2, resource_data: ResourceData) -> BuildValidatorReturn:
	var return_data: BuildValidatorReturn = null
	for validator in validators:
		var stats: EntityStats = null
		if building != null:
			stats = building.stats
		var building_data_to_use = building_data
		if building_data_to_use == null and building != null:
			building_data_to_use = building.building_data

		return_data = validator.is_valid(tree, global_position, building_data_to_use, stats, resource_data)
		if !return_data.get_can_build():
			break

	return return_data

func execute(_global_position: Vector2, _target_building: Node2D, _target_node: Node ) -> int:
	return 0
	
func get_ghost_icon() -> Texture:
	if use_build_entry_icon_as_ghost and building_data != null and building_data.texture != null:
		return building_data.texture
	return ghost_icon

func get_tool_name() -> String:
	return "NOT_SET"