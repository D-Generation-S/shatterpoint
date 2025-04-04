class_name Spawner extends PathFollow2D

signal spawning_completed()
signal spawning_started()
signal request_path(icon: Texture, start_node: Node2D, end_node: Node2D, amount: int, time: float)

@export var configuration: SpawnerConfiguration

@export var enemy_root_node: Node
@export var active_after_wave: int = 0

var overlay: ResourceOverlay
var spawn_information: SpawnInformation
var is_active: bool = false

var timer: Timer
var did_spawn_enemy: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	process_mode = PROCESS_MODE_DISABLED
	timer = Timer.new()
	timer.autostart = false
	await get_tree().physics_frame
	overlay = GlobalDataAccess.get_resource_overlay()

	recalculate_balance()

	timer.timeout.connect(spawn_enemy)
	add_child(timer)

func recalculate_balance() -> void:
	var spawner_count: float = get_active_spawner_count()
	configuration.set_balance(1.0 / spawner_count)

func get_active_spawner_count() -> int:
	var spawner_count: int = get_tree().get_nodes_in_group("spawner").filter(func(spawner): return spawner.is_spawner_active()).size()
	return spawner_count

func spawn_enemy():
	var number_to_spawn = randi_range(1, configuration.max_simultaneous_spawn)
	for i in range(number_to_spawn):
		var valid_entries = spawn_information.spawn_sets.filter(func(data_set): return data_set.amount > 0)
		if valid_entries.size() == 0:
			spawning_completed.emit()
			timer.stop()
			return
		if !did_spawn_enemy:
			did_spawn_enemy = true
			spawning_started.emit()
		var entry = valid_entries[randi_range(0, valid_entries.size() - 1)] as SpawnSet
		progress_ratio = randf()
		
		var enemy = entry.enemy_data.enemy_template.instantiate() as Enemy
		if enemy == null:
			printerr("Could not find enemy template!")
		enemy.enemy_data = entry.enemy_data
		enemy.global_position = global_position
		enemy_root_node.add_child(enemy)
		enemy.activate.call_deferred()
		entry.amount -= 1

func unit_scrap_path_requested(unit_node: Node2D, amount: int):
	if amount == 0:
		return
	request_path.emit(overlay.scrap_icon, unit_node, overlay.scrap_animation_node, amount, 1)

func prepare_spawner(wave_number: int):
	if wave_number > active_after_wave:
		is_active = true

func prepare_wave(wave_number: int):
	recalculate_balance()
	spawn_information = configuration.generate_unit_set(wave_number)
	timer.wait_time = spawn_information.spawn_interval_in_seconds

func is_spawner_active():
	return is_active

func ready_up():
	did_spawn_enemy = false
	process_mode = PROCESS_MODE_INHERIT
	timer.start()

func disable():
	process_mode = PROCESS_MODE_DISABLED
	if timer != null:
		timer.stop()
