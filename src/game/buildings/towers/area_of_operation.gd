class_name AreaOfOperation extends Area2D

signal something_entered()

@onready var collision_shape: CollisionShape2D = $"CollisionCircle"
var custom_draw: bool = false

var body_active: bool = true
var shape_active: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	process_mode = PROCESS_MODE_PAUSABLE
	body_entered.connect(_body_entered)
	area_entered.connect(_shape_entered)
	collision_shape.shape = CircleShape2D.new()
	

func _body_entered(_body: Node2D):
	if !body_active:
		return
	something_entered.emit()

func _shape_entered(_activearea: Area2D):
	if !shape_active:
		return
	something_entered.emit()
	
func change_body_or_shape_entered(body_is_active: bool, shape_is_active: bool):
	body_active = body_is_active
	shape_active = shape_is_active

func draw_attack_area(on: bool):
	custom_draw = on
	queue_redraw()

func set_radius(radius: float):
	if collision_shape.shape is CircleShape2D:
		collision_shape.shape.radius = radius
		queue_redraw()

func _draw():
	if !custom_draw:
		return
	draw_circle(position, collision_shape.shape.radius, Color(1,0,0,0.2), true)
