class_name Navigation extends NavigationAgent2D

signal got_stuck()
signal new_target_required()
signal change_velocity(new_velocity: Vector2)

@export var controlled_character: CharacterBody2D
@export var position_scan_interval_in_physic_ticks: int = 60
@export var max_reset_pos: int = 50
@export var threshold: float = 5

var position_counter: int = 0
var scan_position: Vector2 = Vector2.ZERO
var main_nav_position: Vector2

var collision_off = false

func _ready():
	velocity_computed.connect(_velocity_computed)
	process_mode = ProcessMode.PROCESS_MODE_DISABLED
	navigation_setup.call_deferred()
	scan_position = controlled_character.global_position

func navigation_setup():
	await get_tree().physics_frame
	process_mode = ProcessMode.PROCESS_MODE_INHERIT


func _physics_process(_delta: float):
	var current_agent_position = controlled_character.global_position
	var next_path_position = get_next_path_position()
	var new_velocity = current_agent_position.direction_to(next_path_position)
	new_velocity = new_velocity.normalized()

	if position_counter > position_scan_interval_in_physic_ticks:
		position_counter = 0
		if controlled_character.global_position.distance_to(scan_position) <= threshold:
			var random_x = controlled_character.position.x + randi_range(-max_reset_pos, max_reset_pos)
			var random_y = controlled_character.position.y + randi_range(-max_reset_pos, max_reset_pos)
			set_move_command(Vector2(random_x, random_y))
			got_stuck.emit()

		scan_position = controlled_character.global_position

	position_counter += 1

	if is_navigation_finished():
		change_velocity.emit(Vector2.ZERO)
		position_counter = 0
		new_target_required.emit()
		process_mode = ProcessMode.PROCESS_MODE_DISABLED

	if avoidance_enabled:
		set_velocity(new_velocity)
	else:
		_velocity_computed(new_velocity)

	controlled_character.move_and_slide()

func set_move_command(target: Vector2):
	target_position = target
	process_mode = ProcessMode.PROCESS_MODE_INHERIT

func set_debug(on: bool):
	debug_enabled = on

func _velocity_computed(safe_velocity: Vector2):
	change_velocity.emit(safe_velocity)