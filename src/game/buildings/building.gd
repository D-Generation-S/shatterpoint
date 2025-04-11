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
@export var building_destroyed_meta: TranslationResource = preload("res://translations/resources/building_destroyed_meta.tres")
@export var custom_destroyed_message: PackedScene = null

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

	GlobalDataAccess.get_modifier_system().modifier_selected.connect(_add_global_modifier)
	for modifier in GlobalDataAccess.get_modifier_system().get_active_modifiers():
		_add_global_modifier(modifier)
	

	texture_changed.emit(building_data.texture)
	if visual is ColorReplaceShader:
		visual.set_color_replacement(building_data.input_color, building_data.output_color)

	building_added.emit(self)

func request_add_projectile(node: Node2D):
	get_parent().add_child(node)

func request_detail_window(request_position: Vector2, size: Vector2, title: String, content: Array[DefaultDetailContent]):
	show_detail_window.emit(request_position, size, title, content, true)

func _add_global_modifier(modifier: SpecialModifierConfiguration):
	if modifier.scope & (1 << ModifierSystem.ModifierScope.TOWER) and is_in_group("tower"):
		add_modifier(modifier.modifier)
	if modifier.scope & (1 << ModifierSystem.ModifierScope.GENERATOR) and is_in_group("generator"):
		add_modifier(modifier.modifier)
	if modifier.scope & (1 << ModifierSystem.ModifierScope.SCRAP_STORAGE) and is_in_group("storage"):
		add_modifier(modifier.modifier)
	if modifier.scope & (1 << ModifierSystem.ModifierScope.UNIT_SPAWNER) and is_in_group("unit_spawner"):
		add_modifier(modifier.modifier)

func add_modifier(modifier: StatModifier):
	var previous_armor = stats.armor
	super(modifier)
	building_data.stats = stats
	building_data_changed.emit(building_data)

	health_changed.emit(stats.hp)
	max_health_changed.emit(stats.max_hp)

	if previous_armor != stats.armor:
		max_armor_changed.emit(stats.armor)
	armor_changed.emit(stats.armor)

func _is_dying():
	super()
	building_removed.emit(self)

func _hp_reached_zero():
	super()
	var message_text = tr(building_destroyed_message.key) % tr(building_data.building_name)
	if custom_destroyed_message:
		var message = custom_destroyed_message.instantiate() as MessageTemplate
		if message:
			var meta_tag = "{\"type\": \"move_camera\", \"data\": \"\", \"additional\": {\"x\": %s, \"y\": %s} }" % [global_position.x, global_position.y]
			message_text = tr(building_destroyed_meta.key) % [destroyed_style.text_color.to_html(), meta_tag, tr(building_data.building_name)]
			message.meta_request.connect(InteractionHandler.handle_interaction)
			message.setup(destroyed_style, message_text, 3, visual.texture)
			
			GlobalDataAccess.get_message_area().add_custom_message(MessagePosition.BOTTOM_RIGHT, message)
			return

	request_message.emit(MessagePosition.BOTTOM_RIGHT, destroyed_style, message_text, 3, visual.texture)
