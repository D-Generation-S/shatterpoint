class_name BuildModeTool extends Resource

@export var validators: Array[BuildValidator] = []
@export var use_build_entry_icon_as_ghost: bool = true
@export var ghost_icon: Texture = null
# This value can be null, this is only required of this should really build something
@export var building_data: TowerData = null


func can_be_used(tree: SceneTree, global_position: Vector2, _resource_data: ResourceData) -> BuildValidatorReturn:
	var return_data: BuildValidatorReturn = null
	for validator in validators:
		return_data = validator.is_valid(tree, global_position, building_data, _resource_data)
		if !return_data.get_can_build():
			break

	return return_data

func execute(_global_position: Vector2, _target_building: Node2D, _target_node: Node ) -> int:
	return 0
	
func get_ghost_icon() -> Texture:
	return ghost_icon
