class_name TowerComponent extends EntityComponent

signal request_fire(target: Node2D, damage: float, penetration: float)
signal projectile_changed(projectile_template: PackedScene)
signal thread_determination_changed(thread_determination: ThreatDetermination)
signal attack_groups_changed(groups: Array[String])
signal change_attack_radius(new_radius: float)
signal update_death_animation(scene: PackedScene)


@onready var cooldown_timer: Timer = $"%AttackTimer"

var isDebug: bool = false
var tower_data: TowerData
var current_thread_determination: ThreatDetermination

var current_target: EntityWithStats = null
var initial_fire: bool = false

var is_on_cooldown: bool = false

var resource_overlay: ResourceOverlay

func _ready():
	resource_overlay = GlobalDataAccess.get_resource_overlay()
	
	cooldown_timer.timeout.connect(_reset_cooldown)
	cooldown_timer.one_shot = true
	cooldown_timer.process_callback = Timer.TIMER_PROCESS_PHYSICS
	cooldown_timer.process_mode = Node.PROCESS_MODE_PAUSABLE

func _reset_cooldown():
	is_on_cooldown = false

func _process(_delta):
	if current_target != null and !is_on_cooldown:
		fire()
		cooldown_timer.start()
		is_on_cooldown = true

func fire():
	if !isDebug:
		if resource_overlay.get_power() < tower_data.power_usage_per_shot:
			return
		resource_overlay.add_power(-tower_data.power_usage_per_shot)
	request_fire.emit(current_target, tower_data.stats.damage, tower_data.stats.armor_penetration)

func enable():
	super()
	initial_fire = true
	process_mode = PROCESS_MODE_INHERIT

func disable():
	super()
	initial_fire = false
	process_mode = PROCESS_MODE_DISABLED

func building_data_updated(building_data: BuildingBase):
	if building_data is TowerData:
		tower_data = building_data
		_trigger_stats_update()
		update_death_animation.emit(building_data.death_animation)

func _trigger_stats_update():
	projectile_changed.emit(tower_data.projectile)
	attack_groups_changed.emit(tower_data.attackable_groups)
	thread_determination_changed.emit(tower_data.allowed_thread_determination[0])
	
	change_attack_radius.emit(tower_data.stats.attack_range)

func set_is_debug(on: bool):
	isDebug = on

func set_current_target(entity: EntityWithStats):
	current_target = entity
	if current_target != null:
		enable()

func tower_active_changed(on: bool):
	if on:
		enable()
	else:
		disable()
