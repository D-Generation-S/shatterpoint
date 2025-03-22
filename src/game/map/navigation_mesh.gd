extends NavigationRegion2D

signal mesh_baken()

@onready var ground_tile_map: TileMapLayer = $"%Ground"
func _ready():
	bake_finished.connect(baking_done)

func _update():
	var tile_size = ground_tile_map.tile_set.tile_size
	var new_polygon = NavigationPolygon.new()
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