class_name HpIsNotFull extends BuildValidator

func is_valid(_tree: SceneTree,
			  _global_mouse_position: Vector2,
			  _building_data: BuildingBase,
			  building_stats: EntityStats,
			  _resource_data: ResourceData) -> BuildValidatorReturn:
	if building_stats.hp == building_stats.max_hp:
		return BuildValidatorReturn.new(false, "BUILDING_AT_FULL_HEALTH")
	return BuildValidatorReturn.new(true, "")
