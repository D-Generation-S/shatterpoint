class_name Building extends EntityWithStats

signal show_detail_window(request_position: Vector2, size: Vector2, title: String, content: Array[DefaultDetailContent], close_others: bool)
signal building_data_changed(building_data: BuildingBase)
signal in_debug_mode(on: bool)
signal building_added(building: Building)
signal building_removed(building: Building)
signal texture_changed(texture: Texture2D)

@export var building_data: BuildingBase
@export var isDebug: bool = false
@export var destroyed_style: MessageStyle
@export var building_destroyed_message: TranslationResource = preload("res://translations/resources/building_destroyed.tres")

@onready var visual: Sprite2D= $"%Visuals"


var resource_overlay: ResourceOverlay

func _ready():
	building_added.connect(GlobalMessageLine.building_was_added)
	building_removed.connect(GlobalMessageLine.building_was_removed)

	building_data = building_data.duplicate()
	in_debug_mode.emit(isDebug)
	_base_stats = building_data.stats
	super()
	building_data.stats.max_hp = stats.max_hp
	building_data_changed.emit(building_data)

	resource_overlay = GlobalDataAccess.get_resource_overlay()
	var detail_system = GlobalDataAccess.get_entity_detail_system()
	show_detail_window.connect(detail_system.request_window)
	

	texture_changed.emit(building_data.texture)
	if visual is ColorReplaceShader:
		visual.set_color_replacement(building_data.input_color, building_data.output_color)

	building_added.emit(self)

func request_add_projectile(node: Node2D):
	get_parent().add_child(node)

func request_detail_window(request_position: Vector2, size: Vector2, title: String, content: Array[DefaultDetailContent]):
	show_detail_window.emit(request_position, size, title, content, true)

func add_modifier(modifier: StatModifier):
	super(modifier)
	building_data.stats = stats
	building_data_changed.emit(building_data)

func _is_dying():
	super()
	building_removed.emit(self)

func _hp_reached_zero():
	super()
	var message = tr(building_destroyed_message.key) % tr(building_data.building_name)
	request_message.emit(MessagePosition.BOTTOM_RIGHT, destroyed_style, message, 3, visual.texture)
