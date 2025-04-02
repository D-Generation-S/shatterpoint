class_name CheckTileMapCollision extends BuildValidator

@export var tile_map_group = "obstracles"

func is_valid(tree: SceneTree,
			  global_mouse_position: Vector2,
			  _building_data: BuildingBase,
			  _building_stats: EntityStats,
			  _resource_data: ResourceData) -> BuildValidatorReturn:
	var tile_maps = tree.get_nodes_in_group(tile_map_group) as Array[Node2D]
	for tile_map in tile_maps:
		if tile_map is TileMapLayer:
			var local_coords = tile_map.to_local(global_mouse_position)
			if tile_map.get_cell_tile_data(tile_map.local_to_map(local_coords)) != null:
				return BuildValidatorReturn.new(false, tr("BUILD_SPACE_BLOCKED"))
	return BuildValidatorReturn.new(true, tr("BUILD_SPACE_BLOCKED"))
