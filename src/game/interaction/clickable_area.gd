extends Area2D

signal interaction_requested()
signal interaction_cancelt()

@onready var interaction_shape: CollisionShape2D = $InteractionShape

var mouse_inside: bool = false

func _ready():
	interaction_enabled()

func _process(_delta):
	if Input.is_action_just_pressed("interact"):
		if mouse_inside:
			interaction_requested.emit()
		else:
			interaction_cancelt.emit()

func interaction_enabled():
	process_mode = PROCESS_MODE_PAUSABLE

func interaction_disabled():
	process_mode = PROCESS_MODE_DISABLED

func _mouse_enter():
	mouse_inside = true

func _mouse_exit():
	mouse_inside = false