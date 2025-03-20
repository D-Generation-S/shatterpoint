class_name InsideOfBuildingArea extends BuildValidator

@export var build_area_group: String = "build_area"

var _build_areas: Array[Area2D] = []

func is_valid(tree: SceneTree,
			  _global_mouse_position: Vector2,
			  _building_data: BuildingBase,
			  _resource_data: ResourceData) -> BuildValidatorReturn:
	check_for_build_areas(tree)
	for build_area in _build_areas:
			if build_area.get_overlapping_areas().any(func(area): return area.is_in_group("build_marker") ):
				return BuildValidatorReturn.new(true, "")
	return BuildValidatorReturn.new(false, "NOT_INSIDE_BUILD_AREA")

func check_for_build_areas(tree: SceneTree):
	if _build_areas.size() > 0:
		return
	for build_area in tree.get_nodes_in_group(build_area_group) as Array[Node2D]:
		if build_area is Area2D:
			_build_areas.append(build_area)
