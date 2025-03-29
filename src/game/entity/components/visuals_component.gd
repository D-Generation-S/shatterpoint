extends Sprite2D

@export var animation_threshold: float = 0.05

var animation: EntityAnimation


func data_changed(data: UnitData):
	if data.animation == null:
		return
	animation = data.animation.duplicate()

func velocity_changed(new_velocity: Vector2):
	if new_velocity.x < 0:
		flip_h = true
	else:
		flip_h = false

	if animation == null:
		return

	if new_velocity.distance_to(Vector2.ZERO) > animation_threshold:
		animation.animate_visuals(self)
	else:
		animation.kill_animation()
