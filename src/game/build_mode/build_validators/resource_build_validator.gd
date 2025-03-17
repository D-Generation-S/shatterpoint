class_name ResourceBuildValidator extends BuildValidator

func is_valid(_tree: SceneTree,
			  _global_mouse_position: Vector2,
			  building_data: TowerData,
			  resource_data: ResourceData) -> BuildValidatorReturn:
	if building_data.scrap_required < resource_data.get_scrap():
		return BuildValidatorReturn.new(true, "")
	return BuildValidatorReturn.new(false, "NO_SCRAP_AVAILABLE")

