extends Camera2D

@export var settings: CameraSettings

var drag: bool = false
var last_mouse_position: Vector2 = Vector2.ZERO

func _ready():
	setup_edge_ares()

func setup_edge_ares():
	for edge in get_tree().get_nodes_in_group("scroll_edge"):
		if edge is EdgeScrollArea:
			edge.edge_triggered.connect(edge_scroll)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	handle_keyboard()
	handle_drag()

func handle_keyboard():
	var velocity = Vector2.ZERO
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
		drag = true

	if Input.is_action_just_released("drag"):
		drag = false

	if drag:
		var delta_drag = get_viewport().get_mouse_position() - last_mouse_position
		position -= delta_drag * settings.drag_speed
	
	last_mouse_position = get_viewport().get_mouse_position()

func edge_scroll(vector: Vector2):
	if !settings.edge_move_enabled:
		return
	position += vector * settings.edge_scroll_speed