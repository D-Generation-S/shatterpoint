extends Node2D

@export var spawn_rings: int = 2
@export var parent_node: Node2D

func data_updated(data: BuildingBase):
	if data is SpawnerStats:
		pass

func spawn_requested(data: UnitData):
	if data.spawn_scrap_price > GlobalDataAccess.get_resource_overlay().get_scrap():
		return


	var template = data.enemy_template.instantiate() as Enemy
	template.global_position = _get_spawn_position()
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

func _get_spawn_position() -> Vector2:
	return global_position
