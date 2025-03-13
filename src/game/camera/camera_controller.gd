extends Camera2D

@export var settings: CameraSettings

var _drag: bool = false
var _last_mouse_position: Vector2 = Vector2.ZERO
var _zoom_tween: Tween
var _zoom_level: float = 5

func _ready():
	setup_edge_ares()
	initial_setting_setup()

func initial_setting_setup():
	position_smoothing_enabled = settings.use_position_smoothing
	position_smoothing_speed = settings.position_smoothing_speed

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
	if Input.is_action_just_pressed("zoom_out"):
		_set_zoom_level(_zoom_level - settings.zoom_steps)
	if Input.is_action_just_pressed("zoom_in"):
		_set_zoom_level(_zoom_level + settings.zoom_steps)
	handle_keyboard()
	handle_drag()

func handle_keyboard():
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

func handle_drag():
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