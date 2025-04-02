class_name ResourceBuildValidator extends BuildValidator

func is_valid(_tree: SceneTree,
			  _global_mouse_position: Vector2,
			  building_data: BuildingBase,
			  _building_stats: EntityStats,
			  resource_data: ResourceData) -> BuildValidatorReturn:
	if building_data.scrap_required <= resource_data.get_scrap():
		return BuildValidatorReturn.new(true, "")
	return BuildValidatorReturn.new(false, tr("NO_SCRAP_AVAILABLE"))

