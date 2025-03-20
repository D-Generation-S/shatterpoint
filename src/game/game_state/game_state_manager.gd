class_name GameStateManager extends Node

enum 
{
	BUILD,
	WAVE
}

signal wave_phase_started()
signal dynamic_start_wave_preperation(number: int)
signal build_phase_started()
signal message_requested(target: int, type: MessageType, message: String, duration: float, icon: Texture)

@export var unit_dead_check_interval: float = 1
@export var message_style: MessageStyle

var current_phase = BUILD
var all_units_spawned: bool = true
var all_units_dead: bool = true

var dead_unit_timer: Timer
var spawners: Array[Spawner]
var completed_spawners = 0
var current_wave: int = 1


func _ready():
	GlobalTickSystem.enable()
	dead_unit_timer = Timer.new()
	dead_unit_timer.autostart = false
	dead_unit_timer.one_shot = true
	dead_unit_timer.wait_time = unit_dead_check_interval
	dead_unit_timer.timeout.connect(check_for_units_alive)
	add_child(dead_unit_timer)

	for spawner in get_tree().get_nodes_in_group("spawner"):
		if spawner is Spawner:
			dynamic_start_wave_preperation.connect(spawner.prepare_wave)
			spawner.spawning_started.connect(spawning_started)
			spawner.spawning_completed.connect(spawn_is_completed)
			wave_phase_started.connect(spawner.ready_up)
			build_phase_started.connect(spawner.disable)

	wave_phase_endet()

func spawn_is_completed():
	completed_spawners += 1
	if completed_spawners >= spawners.size():
		completed_spawners = 0
		all_units_spawned = true
		wave_phase_endet()

func check_for_units_alive():
	var units = get_tree().get_nodes_in_group("enemy")
	if units.size() == 0 and all_units_spawned:
		all_units_dead = true
		wave_phase_endet()
		return

	dead_unit_timer.start()

func spawning_started():
	if dead_unit_timer.paused:
		return
	dead_unit_timer.start()

func wave_phase_endet():
	if all_units_dead and all_units_spawned:
		dynamic_start_wave_preperation.emit(current_wave)
		current_wave += 1
		build_phase_started.emit()
		message_requested.emit(MessagePosition.CENTER, message_style, "BUILD_PHASE_STARTED", 1.0)

func build_phase_endet():
	all_units_spawned = false
	all_units_dead = false
	wave_phase_started.emit()
	message_requested.emit(MessagePosition.CENTER, message_style, "WAVE_PHASE_STARTED", 1.0)
