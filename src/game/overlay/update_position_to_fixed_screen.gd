extends Node2D

@export var screen_coordinates: Vector2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	global_position = get_canvas_transform().affine_inverse() * screen_coordinates
