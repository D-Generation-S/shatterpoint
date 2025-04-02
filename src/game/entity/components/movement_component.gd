extends Node2D

signal change_velocity(new_velocity: Vector2)

var movement_speed: float = 40


func data_updated(data: UnitData):
	movement_speed = data.movement_speed

func set_velocity(velocity: Vector2):
	change_velocity.emit(velocity * movement_speed)