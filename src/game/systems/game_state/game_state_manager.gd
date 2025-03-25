class_name GameStateManager extends Node

enum 
{
	BUILD,
	WAVE
}

signal wave_phase_started()
signal dynamic_start_spawner_pre_calculate(number: int)
signal dynamic_start_wave_preparation(number: int)
signal build_phase_started()
signal message_requested(target: int, type: MessageType, message: String, duration: float, icon: Texture)

@export var unit_dead_check_interval: float = 1
@export var message_style: MessageStyle

@export var base_build_mode_time: float = 30

var current_phase = BUILD
var all_units_spawned: bool = true
var all_units_dead: bool = true

var timer_shown: bool = true
var build_mode_timer: Timer
var dead_unit_timer: Timer
var spawners: Array[Spawner]
var completed_spawners = 0
var current_wave: int = 0


func _ready():
	GlobalTickSystem.enable()
	dead_unit_timer = Timer.new()
	dead_unit_timer.autostart = false
	dead_unit_timer.one_shot = true
	dead_unit_timer.wait_time = unit_dead_check_interval
	dead_unit_timer.timeout.connect(check_for_units_alive)

	_setup_build_mode_timer()

	add_child(dead_unit_timer)

	for spawner in get_tree().get_nodes_in_group("spawner"):
		if spawner is Spawner:
			dynamic_start_spawner_pre_calculate.connect(spawner.prepare_spawner)
			dynamic_start_wave_preparation.connect(spawner.prepare_wave)
			spawner.spawning_started.connect(spawning_started)
			spawner.spawning_completed.connect(spawn_is_completed)
			wave_phase_started.connect(spawner.ready_up)
			build_phase_started.connect(spawner.disable)

func _process(_delta):
	_handle_build_phase_warning()	

func _unhandled_input(event):
	if event.is_action("skip_building_phase") and current_phase == BUILD:
		build_phase_endet()

func _setup_build_mode_timer():
	build_mode_timer = Timer.new()
	build_mode_timer.wait_time = base_build_mode_time
	build_mode_timer.one_shot = true
	build_mode_timer.autostart = false
	build_mode_timer.timeout.connect(build_phase_endet)
	
	add_child(build_mode_timer)

func _handle_build_phase_warning():
	if build_mode_timer.time_left < 6 and not timer_shown:
		var message = tr("BUILD_TIME_LEFT")
		var time_left: int = build_mode_timer.time_left
		message = message.replace("%TIME%", str(time_left))
		message_requested.emit(MessagePosition.CENTER, message_style, message, 2)
		timer_shown = true

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
		dynamic_start_spawner_pre_calculate.emit(current_wave)
		dynamic_start_wave_preparation.emit(current_wave)
		current_wave += 1
		build_phase_started.emit()
		message_requested.emit(MessagePosition.CENTER, message_style, "BUILD_PHASE_STARTED", 1.0)

		current_phase = BUILD
		build_mode_timer.start()
		timer_shown = false

func build_phase_endet():
	all_units_spawned = false
	all_units_dead = false
	wave_phase_started.emit()
	if !build_mode_timer.is_stopped():
		build_mode_timer.stop()
	current_phase = WAVE
	var message = tr("WAVE_PHASE_STARTED") % current_wave
	message_requested.emit(MessagePosition.CENTER, message_style, message, 1.0)

func start_game():
	all_units_dead = true
	all_units_spawned = true
	wave_phase_endet()