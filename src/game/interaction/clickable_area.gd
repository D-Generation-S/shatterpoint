extends Area2D

signal interaction_requested()
signal interaction_canceled()

@onready var interaction_shape: CollisionShape2D = $InteractionShape

var mouse_inside: bool = false

func _ready():
	interaction_enabled()

func _unhandled_input(event):
	if event.is_action("interact") and Input.is_action_just_pressed("interact"):
		if mouse_inside:
			interaction_requested.emit()
		else:
			interaction_canceled.emit()

func interaction_enabled():
	process_mode = PROCESS_MODE_PAUSABLE

func interaction_disabled():
	process_mode = PROCESS_MODE_DISABLED

func _mouse_enter():
	mouse_inside = true

func _mouse_exit():
	mouse_inside = false

func change_radius(radius: float):
	var shape = interaction_shape.shape
	if shape is CircleShape2D:
		shape.radius = radius