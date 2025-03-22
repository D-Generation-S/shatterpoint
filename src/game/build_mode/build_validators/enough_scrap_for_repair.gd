class_name EnoughScrapForRepair extends BuildValidator

func is_valid(tree: SceneTree,
			  _global_mouse_position: Vector2,
			  building_data: BuildingBase,
			  building_stats: EntityStats,
			  resource_data: ResourceData) -> BuildValidatorReturn:
	var current_hp = building_stats.hp
	var max_hp = building_stats.max_hp
	var scrap_required_for_building = building_data.scrap_required

	var percent_alive = 1 - (current_hp / max_hp)
	var repair_costs: int = ceili(scrap_required_for_building * percent_alive)
	if repair_costs <= resource_data.get_scrap():
		return BuildValidatorReturn.new(true, "")
	return BuildValidatorReturn.new(false, "NO_SCRAP_AVAILABLE")
