class_name Building extends EntityWithStats

signal building_data_changed(building_data: BuildingBase)
signal in_debug_mode(on: bool)

@export var building_data: BuildingBase
@export var isDebug: bool = false

@onready var visual: Sprite2D= $"%Visuals"


var resource_overlay: ResourceOverlay

func _ready():
	in_debug_mode.emit(isDebug)
	building_data_changed.emit(building_data)
	_base_stats = building_data.stats
	super()
	for overlay in get_tree().get_nodes_in_group("overlay"):
		if overlay is ResourceOverlay:
			resource_overlay = overlay
	visual.texture = building_data.texture
	if visual is ColorReplaceShader:
		visual.set_color_replacement(building_data.input_color, building_data.output_color)

func _is_dying():
	pass
