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

@export var game_end_screen_template: PackedScene
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
var current_wave: int = 1

var input_locked: bool = false

func _ready():
	_register_commands()
	GlobalTickSystem.enable()
	dead_unit_timer = Timer.new()
	dead_unit_timer.autostart = false
	dead_unit_timer.one_shot = true
	dead_unit_timer.wait_time = unit_dead_check_interval
	dead_unit_timer.timeout.connect(check_for_units_alive)
	Console.console_open.connect(func(): input_locked = true)
	Console.console_closed.connect(func(): input_locked = false)

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
	if input_locked:
		return
	if event.is_action("skip_building_phase") and current_phase == BUILD:
		build_phase_ended()

func _setup_build_mode_timer():
	build_mode_timer = Timer.new()
	build_mode_timer.wait_time = base_build_mode_time
	build_mode_timer.one_shot = true
	build_mode_timer.autostart = false
	build_mode_timer.timeout.connect(build_phase_ended)
	
	add_child(build_mode_timer)

func _handle_build_phase_warning():
	if build_mode_timer.time_left < 6 and not timer_shown:
		var message = tr("BUILD_TIME_LEFT")
		var time_left: int = int(build_mode_timer.time_left)
		message = message % time_left
		message_requested.emit(MessagePosition.CENTER, message_style, message, 2)
		timer_shown = true

func spawn_is_completed():
	completed_spawners += 1
	if completed_spawners >= spawners.size():
		completed_spawners = 0
		all_units_spawned = true
		wave_phase_ended()

func check_for_units_alive():
	var units = get_tree().get_nodes_in_group("enemy")
	if units.size() == 0 and all_units_spawned:
		all_units_dead = true
		wave_phase_ended()
		return

	dead_unit_timer.start()

func spawning_started():
	if dead_unit_timer.paused:
		return
	dead_unit_timer.start()

func wave_phase_ended():
	if all_units_dead and all_units_spawned:
		dynamic_start_spawner_pre_calculate.emit(current_wave)
		dynamic_start_wave_preparation.emit(current_wave)
		current_wave += 1
		build_phase_started.emit()
		message_requested.emit(MessagePosition.CENTER, message_style, tr("BUILD_PHASE_STARTED"), 1.0)

		current_phase = BUILD
		build_mode_timer.start()
		timer_shown = false

func build_phase_ended():
	all_units_spawned = false
	all_units_dead = false
	wave_phase_started.emit()
	if !build_mode_timer.is_stopped():
		build_mode_timer.stop()
	current_phase = WAVE
	var message = tr("WAVE_PHASE_STARTED") % (current_wave - 1)
	message_requested.emit(MessagePosition.CENTER, message_style, message, 1.0)
	GlobalMessageLine.request_rebake()

func start_game():
	all_units_dead = true
	all_units_spawned = true
	wave_phase_ended()

func game_has_been_lost():
	var end_screen = game_end_screen_template.instantiate() as GameEnd
	end_screen.set_current_wave(current_wave - 1)
	var popup_manager = GlobalDataAccess.get_popup_manager()
	popup_manager.show_popup(PopupPosition.CENTER, end_screen, true)
	pass

func _register_commands():
	Console.register_custom_command("start_wave", _command_start_wave, [], "Start the wave phase")
	Console.register_custom_command("start_build", _command_start_build, [], "Start the build phase")
	Console.register_custom_command("set_wave", _command_set_wave, ["(int) wave number to set"], "Start the build phase")

func _command_start_wave() -> String:
	build_phase_ended()
	return "Wave phase started"

func _command_start_build() -> String:
	wave_phase_ended()
	return "Build phase started"

func _command_set_wave(wave: String) -> String:
	if !wave.is_valid_int():
		return "Argument is not a valid int"
	current_wave = int(wave)
	return "Wave set to %d" % current_wave

func _exit_tree():
	Console.remove_command("start_wave")
	Console.remove_command("start_build")
	Console.remove_command("set_wave")