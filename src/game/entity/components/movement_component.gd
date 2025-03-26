extends Node2D

signal change_velocity(new_veclocity: Vector2)
signal flip_horizontal(flip: bool)

var movement_speed: float = 40


func data_updated(data: UnitData):
	movement_speed = data.movement_speed
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_velocity(velocity: Vector2):
	if velocity.x < 0:
		flip_horizontal.emit(true)
	else:
		flip_horizontal.emit(false)
	change_velocity.emit(velocity * movement_speed)