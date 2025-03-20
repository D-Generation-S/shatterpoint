class_name BuildValidator extends Resource



func is_valid(_tree: SceneTree,
			  _global_mouse_position: Vector2,
			  _building_data: BuildingBase,
			  _resource_data: ResourceData) -> BuildValidatorReturn:
	return BuildValidatorReturn.new(true, "")