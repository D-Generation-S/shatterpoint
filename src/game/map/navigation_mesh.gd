extends NavigationRegion2D

signal mesh_baken()

@export var cell_size: float = 5
@export var agent_radius: float = 20
@export var source_geometry_group: String = "navigation_polygon_source"
@export_flags_2d_physics var collision_map: int = 9

@onready var ground_tile_map: TileMapLayer = $"%Ground"

var should_rebake: bool = true

func _ready():
	bake_finished.connect(baking_done)
	GlobalMessageLine.building_added.connect(_buildings_changed)
	GlobalMessageLine.building_removed.connect(_buildings_changed)
	GlobalMessageLine.rebake_requested.connect(_rebake_if_needed)
	GlobalDataAccess.set_grid_template(ground_tile_map)
	
	await get_tree().physics_frame
	NavigationServer2D.map_set_cell_size((get_world_2d().get_navigation_map()), cell_size)
	await get_tree().physics_frame

	call_deferred("_build_up")

func _build_up():
	navigation_polygon = NavigationPolygon.new()
	navigation_polygon.cell_size = NavigationServer2D.map_get_cell_size(get_world_2d().get_navigation_map())
	var tile_size = ground_tile_map.tile_set.tile_size

	navigation_polygon.parsed_collision_mask = collision_map
	navigation_polygon.agent_radius = agent_radius
	navigation_polygon.parsed_geometry_type = NavigationPolygon.PARSED_GEOMETRY_BOTH
	navigation_polygon.source_geometry_group_name = source_geometry_group
	navigation_polygon.source_geometry_mode = NavigationPolygon.SOURCE_GEOMETRY_GROUPS_WITH_CHILDREN
	navigation_polygon.clear()
	navigation_polygon.add_outline(
		PackedVector2Array(
			[
				Vector2(ground_tile_map.get_used_rect().position.x * tile_size.x, ground_tile_map.get_used_rect().position.y * tile_size.y),
				Vector2(ground_tile_map.get_used_rect().end.x * tile_size.x, ground_tile_map.get_used_rect().position.y * tile_size.y),
				Vector2(ground_tile_map.get_used_rect().end.x * tile_size.x, ground_tile_map.get_used_rect().end.y * tile_size.y),
				Vector2(ground_tile_map.get_used_rect().position.x * tile_size.x, ground_tile_map.get_used_rect().end.y * tile_size.y),
			]
		)
		
	)

func _update():
	if should_rebake:
		should_rebake = false

	navigation_polygon.clear_polygons()
	await get_tree().physics_frame

	
	bake_navigation_polygon()

func rebake():
	_update()

func baking_done():
	mesh_baken.emit()

func _buildings_changed(_building: Building):
	rebake_requested()

func rebake_requested():
	should_rebake = true

func _rebake_if_needed():
	if should_rebake:
		should_rebake = false
		rebake()