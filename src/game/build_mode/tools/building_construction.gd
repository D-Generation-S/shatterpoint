class_name BuildingConstruction extends BuildModeTool

@export var building_placed_sound: AudioStream
@export var building_template: PackedScene
@export var building_group: String = "building"

func execute(global_position: Vector2, _target_building: Node2D, target_node: Node) -> int:
	var template = building_template.instantiate() as EntityWithStats
	var scrap_usage = 0
	template.global_position = global_position
	if !template.is_in_group(building_group):
		template.add_to_group(building_group)

	if template is Building:
		template.building_data = building_data
		scrap_usage = -building_data.scrap_required

	target_node.add_child(template)
	GlobalSoundManager.play_sound_at_position(global_position, building_placed_sound, 2000, randf_range(0.9, 1.1))
	return scrap_usage

func get_tool_name():
	if building_data != null:
		return building_data.building_name
	else:
		return super()
	
 