class_name DrivingAnimation extends EntityAnimation

@export var max_movement: Vector2 = Vector2(0, -3)
@export var speed: float = 0.15

func animate_visuals(visuals: Sprite2D):
	if tween != null and tween.is_valid():
		return
	tween = visuals.create_tween()
	tween.tween_property(visuals, "position", max_movement, speed)
	tween.tween_property(visuals, "position", Vector2(0, 0), speed)
	tween.finished.connect(func(): 
		animate_visuals(visuals)
	)

