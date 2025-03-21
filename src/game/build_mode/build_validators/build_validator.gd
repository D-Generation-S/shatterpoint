class_name BuildValidator extends Resource



func is_valid(_tree: SceneTree,
			  _global_mouse_position: Vector2,
			  _building_data: BuildingBase,
			  _building_stats: EntityStats,
			  _resource_data: ResourceData) -> BuildValidatorReturn:
	return BuildValidatorReturn.new(true, "")