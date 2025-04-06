class_name SpawnerPopup extends DefaultDetailContent

signal spawn_requested(data: UnitData)

@export var unit_node: Control

func update_spawn_templates(unit_data: Array[UnitData]):
	for child in unit_node.get_children():
		child.queue_free()

	for unit in unit_data:
		var button = UnitSpawnButton.new(unit)
		button.spawn_requested.connect(_request_spawn_now)
		unit_node.add_child(button)


func _request_spawn_now(data: UnitData):
	spawn_requested.emit(data)
	
