extends NavigationRegion2D

signal mesh_baken()

@export var agent_radius: float = 20
@export var source_geometry_group: String = "navigation_polygon_source"
@export_flags_2d_physics var collision_map: int = 9

@onready var ground_tile_map: TileMapLayer = $"%Ground"
func _ready():
	bake_finished.connect(baking_done)
	GlobalDataAccess.set_grid_template(ground_tile_map)

func _update():
	var tile_size = ground_tile_map.tile_set.tile_size
	var new_polygon = NavigationPolygon.new()
	new_polygon.parsed_collision_mask = collision_map
	new_polygon.agent_radius = agent_radius
	new_polygon.parsed_geometry_type = NavigationPolygon.PARSED_GEOMETRY_BOTH
	new_polygon.source_geometry_group_name = source_geometry_group
	new_polygon.source_geometry_mode = NavigationPolygon.SOURCE_GEOMETRY_GROUPS_WITH_CHILDREN
	new_polygon.clear()
	new_polygon.add_outline(
		PackedVector2Array(
			[
				Vector2(ground_tile_map.get_used_rect().position.x * tile_size.x, ground_tile_map.get_used_rect().position.y * tile_size.y),
				Vector2(ground_tile_map.get_used_rect().end.x * tile_size.x, ground_tile_map.get_used_rect().position.y * tile_size.y),
				Vector2(ground_tile_map.get_used_rect().end.x * tile_size.x, ground_tile_map.get_used_rect().end.y * tile_size.y),
				Vector2(ground_tile_map.get_used_rect().position.x * tile_size.x, ground_tile_map.get_used_rect().end.y * tile_size.y),
			]
		)
		
	)
	navigation_polygon = new_polygon
	bake_navigation_polygon()

func rebake():
	_update()

func baking_done():
	mesh_baken.emit()