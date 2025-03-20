class_name Tower extends EntityWithStats

@export var tower_data: TowerData
@export var current_thread_determination: ThreatDetermination

@onready var visual: Sprite2D= $"%Visuals"
@onready var area_of_operation: AreaOfOperation = $"%AreaOfOperation"
@onready var attack_timer: Timer = $"%AttackTimer"
@onready var _health_bar: AnimatedHealthBar = $"%HealthBar"

var current_target: Enemy = null
var selected: bool = false
var initial_fire: bool = false
var max_hp: float = 0

var resource_overlay: ResourceOverlay

# Called when the node enters the scene tree for the first time.
func _ready():
	_base_stats = tower_data.stats
	max_hp = tower_data.stats.hp
	super()

	for overlay in get_tree().get_nodes_in_group("overlay"):
		if overlay is ResourceOverlay:
			resource_overlay = overlay
	
	_health_bar.max_value = max_hp
	_health_bar.value = stats.hp
	_health_bar.visible = false

	attack_timer.timeout.connect(fire)
	attack_timer.one_shot = true
	attack_timer.process_callback = Timer.TIMER_PROCESS_PHYSICS

	current_thread_determination = tower_data.allowed_thread_determination[0]
	visual.texture = tower_data.texture
	area_of_operation.set_radius(stats.attack_range)
	if visual is ColorReplaceShader:
		visual.set_color_replacement(tower_data.input_color, tower_data.output_color)

func _process(_delta):
	var possible_targets = area_of_operation.get_overlapping_bodies().filter(target_filter)
	var enemy_targets: Array[Enemy] = []
	for target in possible_targets:
		if target is Enemy:
			enemy_targets.append(target)
	if enemy_targets.size() == 0:
		disabled()
		return
	
	current_target = current_thread_determination.get_threat(self, enemy_targets)
	if current_target != null:
		if initial_fire:
			initial_fire = false
			fire()
		start_attack_timer()
		return

func start_attack_timer():
	if attack_timer.time_left > 0:
		return
	attack_timer.start(stats.fire_rate)

func fire():
	if resource_overlay.get_power() < tower_data.power_usage_per_shot:
		return
	resource_overlay.add_power(-tower_data.power_usage_per_shot)
	var projectile = tower_data.projectile.instantiate() as Projectile
	projectile.setup(self.global_position, current_target, stats.damage, 0, self)
	add_child(projectile)
	projectile.fire()

func target_filter(target: Node2D) -> bool:
	var can_be_targeted = false
	if target is Enemy:
		for group in target.get_groups():
			if is_targetable_group(group):
				can_be_targeted = true
				break
		
	return can_be_targeted

func is_targetable_group(group: String):
	return tower_data.attackable_groups.find(group) != -1

func get_target() -> Node2D:
	return null

func is_active():
	initial_fire = true
	process_mode = PROCESS_MODE_INHERIT

func disabled():
	initial_fire = false
	attack_timer.stop()
	process_mode = PROCESS_MODE_DISABLED

func interacting():
	selected = true
	area_of_operation.draw_attack_area(selected)
	pass

func interaction_cancelt():
	selected = false
	area_of_operation.draw_attack_area(selected)
	pass

func deal_damage(amount: int):
	stats.hp -= amount
	stats.hp = clampf(stats.hp, 0, max_hp)
	if stats.hp == 0:
		destroy()
		return

	_health_bar.update_value(stats.hp)

func destroy():
	queue_free()
