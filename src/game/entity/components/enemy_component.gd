extends Node2D

signal request_fire(target: Node2D, damage: float, penetration: float)
signal projectile_changed(projectile_template: PackedScene)
signal thread_determination_changed(thread_determination: ThreatDetermination)
signal attack_groups_changed(groups: Array[String])
signal change_attack_radius(new_radius: float)

signal death_scene_changed(scene: PackedScene)

@onready var cooldown_timer: Timer = $"%AttackTimer"

var initial_fire: bool = false
var current_target: EntityWithStats = null
var stats: UnitData
var is_on_cooldown: bool = false

func _ready():
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

func _start_attack_timer():
	if cooldown_timer.time_left > 0:
		return
	cooldown_timer.start(stats.stats.fire_rate)

func enemy_data_changed(enemy_data: UnitData):
	stats = enemy_data
	death_scene_changed.emit(enemy_data.death_animation)
	_updated_stats()

func fire():
	request_fire.emit(current_target, stats.stats.damage, stats.stats.armor_penetration)

func _updated_stats():
	projectile_changed.emit(stats.projectile)
	thread_determination_changed.emit(stats.allowed_thread_determination.pick_random())
	attack_groups_changed.emit(stats.attackable_groups)
	change_attack_radius.emit(stats.stats.attack_range)

	
func set_current_target(entity: EntityWithStats):
	current_target = entity
	if current_target != null:
		enable()

func enable():
	initial_fire = true
	process_mode = PROCESS_MODE_INHERIT

func disable():
	initial_fire = false
	process_mode = PROCESS_MODE_DISABLED

func enemy_active_changed(on: bool):
	if on:
		enable()
	else:
		disable()