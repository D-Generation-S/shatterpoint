class_name BuildSpaceBlocked extends BuildValidator

@export var building_group: String = "building"

func is_valid(tree: SceneTree,
			  global_mouse_position: Vector2,
			  building_data: TowerData,
			  resource_data: ResourceData) -> BuildValidatorReturn:
	for building in tree.get_nodes_in_group(building_group) as Array[Node2D]:
		if building.global_position == global_mouse_position:
			return BuildValidatorReturn.new(false, "BUILD_SPACE_BLOCKED")

	
	return BuildValidatorReturn.new(true, "")
