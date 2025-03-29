class_name RepairBuilding extends BuildModeTool

@export var return_name: String = "REPAIR"
@export var building_group: String = "building"

func execute(_global_position: Vector2, target_building: Node2D, _target_node: Node) -> int:
	if target_building is Building:
		var current_hp = target_building.stats.hp
		var max_hp = target_building.stats.max_hp
		var scrap_required_for_building = target_building.building_data.scrap_required

		var percent_alive = 1 - (current_hp / max_hp)
		var repair_costs: int = ceili(scrap_required_for_building * percent_alive)
		if repair_costs == 0:
			return 0

		target_building.deal_damage(current_hp - max_hp)
		return -repair_costs
	return 0

func get_tool_name() -> String:
	return return_name
