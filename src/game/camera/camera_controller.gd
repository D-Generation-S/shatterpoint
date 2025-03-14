extends Camera2D

@export var settings: CameraSettings
@export var home_move_time: float = 1
@export var home_node_group: String = "home"
@export var wave_node_group: String = "wave_position"

var _drag: bool = false
var _last_mouse_position: Vector2 = Vector2.ZERO
var _zoom_tween: Tween
var _zoom_level: float = 5
var _input_active: bool = true
var _home_position: CameraPosition = null
var _wave_position: CameraPosition = null
var home_move_tween: Tween
var last_navigation_point: Vector2 = Vector2.ZERO

func _ready():
	setup_edge_ares()
	initial_setting_setup()
	_home_position = get_tree().get_first_node_in_group(home_node_group) as CameraPosition
	_wave_position = get_tree().get_first_node_in_group(wave_node_group) as CameraPosition

func initial_setting_setup():
	position_smoothing_enabled = settings.use_position_smoothing
	position_smoothing_speed = settings.position_smoothing_speed
	zoom = Vector2(_zoom_level, _zoom_level)

func setup_edge_ares():
	for edge in get_tree().get_nodes_in_group("scroll_edge"):
		if edge is EdgeScrollArea:
			edge.edge_triggered.connect(edge_scroll)

func _set_zoom_level(value: float) -> void:
	_zoom_level = clamp(value, settings.min_zoom, settings.max_zoom)
	_zoom_tween = create_tween()
	_zoom_tween.set_trans(Tween.TRANS_SINE)
	_zoom_tween.set_ease(Tween.EASE_OUT)
	_zoom_tween.tween_method(_update_zoom, zoom.x, _zoom_level, settings.zoom_duration)

func _update_zoom(value: float):
	zoom = Vector2(value, value)

func _process(_delta):
	if not _input_active:
		if global_position.distance_to(last_navigation_point) < 1:
			last_navigation_point = Vector2.ZERO
			_input_active = true
		return
	if Input.is_action_pressed("go_home"):
		animate_camera_scroll(_home_position)
	_handle_zoom()
	_handle_keyboard()
	_handle_drag()

func animate_camera_scroll(target_position: CameraPosition):
	_set_zoom_level(target_position.target_zoom)
	scroll_to_position(target_position.global_position)

func scroll_to_position(new_position: Vector2):
	_input_active = false
	last_navigation_point = new_position
	home_move_tween = create_tween()
	home_move_tween.tween_property(self, "position", new_position, home_move_time)
	pass

func _handle_zoom():
	if Input.is_action_just_pressed("zoom_out"):
		_set_zoom_level(_zoom_level - settings.zoom_steps)
	if Input.is_action_just_pressed("zoom_in"):
		_set_zoom_level(_zoom_level + settings.zoom_steps)

func _handle_keyboard():
	var velocity: Vector2 = Vector2.ZERO
	if Input.is_action_pressed("move_up"):
		velocity += Vector2.UP
	if Input.is_action_pressed("move_down"):
		velocity += Vector2.DOWN
	if Input.is_action_pressed("move_left"):
		velocity += Vector2.LEFT
	if Input.is_action_pressed("move_right"):
		velocity += Vector2.RIGHT
		
	velocity = velocity.normalized()
	position += velocity * settings.move_speed

	velocity = Vector2.ZERO

func _handle_drag():
	if !settings.mouse_drag_enabled:
		return
	if Input.is_action_pressed("drag"):
		_drag = true

	if Input.is_action_just_released("drag"):
		_drag = false

	if _drag:
		var delta_drag: Vector2 = get_viewport().get_mouse_position() - _last_mouse_position
		position -= delta_drag * settings.drag_speed
	
	_last_mouse_position = get_viewport().get_mouse_position()

func edge_scroll(vector: Vector2):
	if !settings.edge_move_enabled:
		return
	position += vector * settings.edge_scroll_speed
