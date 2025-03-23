class_name Building extends EntityWithStats

signal show_detail_window(request_position: Vector2, size: Vector2, title: String, content: Array[DefaultDetailContent])
signal building_data_changed(building_data: BuildingBase)
signal in_debug_mode(on: bool)

@export var building_data: BuildingBase
@export var isDebug: bool = false

@onready var visual: Sprite2D= $"%Visuals"


var resource_overlay: ResourceOverlay

func _ready():
	building_data = building_data.duplicate()
	in_debug_mode.emit(isDebug)
	building_data_changed.emit(building_data)
	_base_stats = building_data.stats
	super()
	for overlay in get_tree().get_nodes_in_group("overlay"):
		if overlay is ResourceOverlay:
			resource_overlay = overlay

	for system in get_tree().get_nodes_in_group("system"):
		if system is EntityDetailWindowSystem:
			show_detail_window.connect(system.request_window)

	visual.texture = building_data.texture
	if visual is ColorReplaceShader:
		visual.set_color_replacement(building_data.input_color, building_data.output_color)

func request_add_projectile(node: Node2D):
	get_parent().add_child(node)

func request_detail_window(request_position: Vector2, size: Vector2, title: String, content: Array[DefaultDetailContent]):
	show_detail_window.emit(request_position, size, title, content)

func add_modifier(modifier: StatModifier):
	super(modifier)
	building_data.stats = stats
	building_data_changed.emit(building_data)

func _is_dying():
	super()
