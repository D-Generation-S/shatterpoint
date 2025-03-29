class_name Enemy extends EntityWithStats

signal entity_data_changed(entity_data: UnitData)

signal died(scrap_drop: int)
signal request_scrap_path(start_node: Node2D, amount: int, Resource)
signal is_in_debug()

@export var is_debug: bool = false
@export var start_ready: bool = false
@export var enemy_data: UnitData 
@export var collision_radius: int = 8

@onready var _visuals: Sprite2D = $"%Visuals"
@onready var _collision: CollisionShape2D = $"%Collision"
@onready var _health_bar: AnimatedHealthBar = $"%HealthBar"
@onready var _armor_bar: AnimatedHealthBar = $"%ArmorBar"

func _ready():
	_base_stats = enemy_data.stats.duplicate()
	super()
	entity_data_changed.emit(enemy_data)
	_health_bar.min_value = 0
	_health_bar.max_value = stats.hp
	_health_bar.value = stats.hp
	_health_bar.visible = false

	_armor_bar.min_value = 0
	_armor_bar.max_value = stats.armor
	_armor_bar.value = stats.armor
	_armor_bar.visible = false
	
	_visuals.texture = enemy_data.texture
	if _collision.shape is CircleShape2D:
		_collision.shape.radius = collision_radius

	is_in_debug.emit(is_debug)
	process_mode = PROCESS_MODE_DISABLED
	if start_ready:
		activate()
	
func _hp_reached_zero():
	var amount = randi_range(enemy_data.min_scrap_drop, enemy_data.max_scrap_drop)
	died.emit(amount)
	request_scrap_path.emit(AutoDeleteNode.new(10, global_position), amount)

func activate():
	process_mode = PROCESS_MODE_INHERIT

func add_projectile_requested(projectile: Projectile):
	get_parent().add_child(projectile)
	