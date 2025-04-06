extends Node2D

@export var spawn_rings: int = 3
@export var parent_node: Node2D

var valid_spawn_positions: Array[SpawnPosition] = []

class SpawnPosition:
	var position: Vector2i
	var blocked: bool
	var used: bool = false

	func _init(pos: Vector2i, active: bool = true):
		position = pos
		blocked = !active

func _ready():
	_create_possible_spawn()
	validate_spawn_positions()

	GlobalMessageLine.building_added.connect(_building_changed)
	GlobalMessageLine.building_removed.connect(_building_changed)

func _building_changed(_building: Building):
	await get_tree().physics_frame
	validate_spawn_positions()

func _create_possible_spawn():
	var _grid_template: TileMapLayer = GlobalDataAccess.get_grid_template()
	var building_position = _get_building_grid_position(_grid_template)
	var initial_size = 3
	var grid_size = _grid_template.tile_set.tile_size
	for i in spawn_rings:
		var multiplier = i + 1
		var top_left: Vector2i = building_position - (grid_size * multiplier)
		for p in range(initial_size):
			var next_x_pos = top_left
			next_x_pos.x = top_left.x + p * grid_size.x
			var x_position_to_add = SpawnPosition.new(next_x_pos)
			valid_spawn_positions.append(x_position_to_add)

			var next_y_pos = top_left
			next_y_pos.y = top_left.y + p * grid_size.y
			var y_position_to_add = SpawnPosition.new(next_y_pos)
			valid_spawn_positions.append(y_position_to_add)

		var bottom_right = building_position + (grid_size * multiplier)
		for p in range(initial_size - 1):
			var next_x_pos = bottom_right
			next_x_pos.x = bottom_right.x - p * grid_size.x
			var x_position_to_add = SpawnPosition.new(next_x_pos)
			valid_spawn_positions.append(x_position_to_add)

			var next_y_pos = bottom_right
			next_y_pos.y = bottom_right.y - p * grid_size.y
			var y_position_to_add = SpawnPosition.new(next_y_pos)
			valid_spawn_positions.append(y_position_to_add)

		initial_size += 2

func validate_spawn_positions():
	var building_positions = get_tree().get_nodes_in_group("building")
	for spawn_position in valid_spawn_positions:
		var valid = true
		for building in building_positions:
			if building is Node2D:
				if spawn_position.position == Vector2i(building.global_position):
					valid = false
					break
		if !valid:
			spawn_position.blocked = !valid
			continue
		var tile_maps = get_tree().get_nodes_in_group("obstracles") as Array[Node2D]
		for tile_map in tile_maps:
			if tile_map is TileMapLayer:
				var map_local = tile_map.to_local(spawn_position.position)
				var grid_local = tile_map.local_to_map(map_local)
				if tile_map.get_cell_tile_data(grid_local) != null:
						valid = false
						break
		spawn_position.blocked = !valid


func _get_building_grid_position(map: TileMapLayer) -> Vector2i:
	var local_map_pos = map.local_to_map(map.to_local(global_position))
	var real_position = map.to_global(map.map_to_local(local_map_pos))


	return real_position

func data_updated(data: BuildingBase):
	if data is SpawnerStats:
		pass

func spawn_requested(data: UnitData):
	if data.spawn_scrap_price > GlobalDataAccess.get_resource_overlay().get_scrap():
		return
	_check_spawn_positions()

	var template = data.enemy_template.instantiate() as Enemy
	var spawn_position = _get_spawn_position()
	if spawn_position == null:
		printerr("No spawn positions left")
		return
	template.global_position = spawn_position.position
	spawn_position.used = true
	template.enemy_data = data
	parent_node.get_parent().add_child(template)
	template.activate()
	GlobalDataAccess.get_resource_overlay().add_scrap(-data.spawn_scrap_price)
	GlobalDataAccess.get_item_path_system().create_new_travel_path(GlobalDataAccess.get_resource_overlay().scrap_icon,
																   GlobalDataAccess.get_resource_overlay().scrap_animation_node,
																   AutoDeleteNode.new(10, global_position),
																   data.spawn_scrap_price,
																   1
																  )
func _check_spawn_positions():
	var some_free = valid_spawn_positions.any(func(data): return !data.used)
	if !some_free:
		for spawn_position in valid_spawn_positions:
			spawn_position.used = false

func _get_spawn_position() -> SpawnPosition:
	var distance: float = 10000
	var target: SpawnPosition = null
	for spawn_position in valid_spawn_positions:
		if spawn_position.used or spawn_position.blocked:
			continue
		var current_distance= global_position.distance_to(spawn_position.position)
		if current_distance < distance:
			distance = current_distance
			target = spawn_position

	return target
