class_name Enemy extends EntityWithStats

signal died(scrap_drop: int)
signal request_scrap_path(start_node: Node2D, amount: int, Resource)
signal reached_town(hp: int)

@export var is_debug: bool = false
@export var start_ready: bool = false
@export var enemy_data: EnemyData 
@export var movement_speed: float = 40
@export var collision_radius: int = 8
@export_enum("ground_target") var target_group: String = "ground_target"

@onready var _visuals: Sprite2D = $"%Visuals"
@onready var _collision: CollisionShape2D = $"%Collision"
@onready var _navigation_agent: Navigation = $"%Navigation"
@onready var _health_bar: AnimatedHealthBar = $"%HealthBar"

var is_alive: bool = true

func _ready():
	_base_stats = enemy_data.stats.duplicate()
	super()
	_health_bar.min_value = 0
	_health_bar.max_value = stats.hp
	_health_bar.value = stats.hp
	_health_bar.visible = false
	
	_visuals.texture = enemy_data.texture
	if _collision.shape is CircleShape2D:
		_collision.shape.radius = collision_radius

	_navigation_agent.debug_enabled = is_debug
	set_target.call_deferred()
	process_mode = PROCESS_MODE_DISABLED
	if start_ready:
		activate()

func set_target():
	var targets = get_tree().get_nodes_in_group(target_group) as Array[Node2D]
	var index = randi_range(0, targets.size() - 1)
	_navigation_agent.set_move_command(targets[index].global_position)
	

func deal_damage(damage: float):
	if not is_alive:
		return
	stats.hp -= damage
	_health_bar.update_value(stats.hp)
	if stats.hp <= 0:
		var amount = randi_range(enemy_data.min_scrap_drop, enemy_data.max_scrap_drop)
		is_alive = false
		died.emit(amount)
		request_scrap_path.emit(AutoDeleteNode.new(10, global_position), amount)

		queue_free()

func activate():
	process_mode = PROCESS_MODE_INHERIT

func town_reached():
	if not is_alive:
		return
	is_alive = false
	reached_town.emit(stats.hp)
	queue_free()
