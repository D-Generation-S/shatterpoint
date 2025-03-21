class_name Generator extends EntityWithStats

@export var generator_data: GeneratorData

@onready var visual: Sprite2D= $"%Visuals"
@onready var _health_bar: AnimatedHealthBar = $"%HealthBar"

var resource_overlay: ResourceOverlay
var path_system: ItemPathSystem

# Called when the node enters the scene tree for the first time.
func _ready():
	_base_stats = generator_data.stats
	super()

	for system in get_tree().get_nodes_in_group("system"):
		if system is ItemPathSystem:
			path_system = system
	for overlay in get_tree().get_nodes_in_group("overlay"):
		if overlay is ResourceOverlay:
			resource_overlay = overlay

	_health_bar.max_value = max_hp
	_health_bar.value = stats.hp
	_health_bar.visible = false

	visual.texture = generator_data.texture

	GlobalTickSystem.game_tick.connect(_game_tick)

	if visual is ColorReplaceShader:
		visual.set_color_replacement(generator_data.input_color, generator_data.output_color)

func _game_tick():
	resource_overlay.add_power(generator_data.generation_per_tick)
	path_system.create_new_travel_path(resource_overlay.energy_icon,
										AutoDeleteNode.new(5, global_position),
										resource_overlay.power_animation_node,
										generator_data.generation_per_tick, 1
										)


func destroy():
	queue_free()
