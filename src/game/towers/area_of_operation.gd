class_name AreaOfOperation extends Area2D

signal something_entered()

@onready var collision_shape: CollisionShape2D = $"CollisionCircle"
var custom_draw: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	process_mode = PROCESS_MODE_PAUSABLE
	body_entered.connect(_body_entered)
	

func _body_entered(_body: Node2D):
	something_entered.emit()

func draw_attack_area(on: bool):
	custom_draw = on
	queue_redraw()

func set_radius(radius: float):
	if collision_shape.shape is CircleShape2D:
		collision_shape.shape.radius = radius

func _draw():
	if !custom_draw:
		return
	draw_circle(position, collision_shape.shape.radius, Color(1,0,0,0.2), true)
