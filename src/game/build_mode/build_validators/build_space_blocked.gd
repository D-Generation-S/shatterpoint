class_name BuildSpaceBlocked extends BuildValidator

@export var building_group: String = "building"
@export var reverse: bool = false

func is_valid(tree: SceneTree,
			  global_mouse_position: Vector2,
			  building_data: BuildingBase,
			  resource_data: ResourceData) -> BuildValidatorReturn:
	for building in tree.get_nodes_in_group(building_group) as Array[Node2D]:
		if building.global_position == global_mouse_position:
			if reverse:
				return BuildValidatorReturn.new(true, "")
			else:
				return BuildValidatorReturn.new(false, "BUILD_SPACE_BLOCKED")

	if reverse:
		return BuildValidatorReturn.new(false, "BUILD_SPACE_BLOCKED")
	else:
		return BuildValidatorReturn.new(true, "")
