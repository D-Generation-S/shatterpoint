class_name DestroyBuilding extends BuildModeTool

func execute(_global_position: Vector2, target_building: Node2D, _target_node: Node ) -> int:
	var scrap_return: int = 0
	if target_building is Building:
		scrap_return = floori(target_building.building_data.scrap_required / 2)
		target_building.destroy()
	return scrap_return
