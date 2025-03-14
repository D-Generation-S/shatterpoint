class_name Navigation extends NavigationAgent2D

@export var max_physic_updates_until_reset: int = 25
@export var max_reset_pos: int = 50
@export var threshold: float = 0.6

@onready var enemy_character: Enemy = $".."

var position_counter: int = 0
var last_position: Vector2 = Vector2.ZERO
var last_nav_position: Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	velocity_computed.connect(_velocity_computed)
	process_mode = ProcessMode.PROCESS_MODE_DISABLED
	navigation_setup.call_deferred()

func navigation_setup():
	await get_tree().physics_frame
	process_mode = ProcessMode.PROCESS_MODE_INHERIT


func _physics_process(_delta: float):
	var current_agent_position = enemy_character.global_position
	var next_path_position = get_next_path_position()
	var new_velocity = current_agent_position.direction_to(next_path_position)
	new_velocity = new_velocity.normalized() * enemy_character.movement_speed

	if position_counter >= max_physic_updates_until_reset:
		position_counter = 0
		last_nav_position = target_position
		var random_x = enemy_character.position.x + randi_range(-max_reset_pos, max_reset_pos)
		var random_y = enemy_character.position.y + randi_range(-max_reset_pos, max_reset_pos)
		print(Vector2(random_x, random_y))
		set_move_command(Vector2(random_x, random_y))

	if enemy_character.global_position.distance_to(last_position) <= threshold:
		position_counter += 1
	else:
		position_counter = 0

	last_position = enemy_character.global_position

	if is_navigation_finished():
		if last_nav_position != Vector2.ZERO:
			set_move_command(last_nav_position)
			last_nav_position = Vector2.ZERO
			return
		return

	if avoidance_enabled:
		set_velocity(new_velocity)
	else:
		_velocity_computed(new_velocity)

	enemy_character.move_and_slide()

func set_move_command(target: Vector2):
	target_position = target

func _velocity_computed(safe_velocity: Vector2):
	enemy_character.velocity = safe_velocity