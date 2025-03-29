class_name WalkAnimation extends EntityAnimation

@export var max_rotation: float = 0.1
@export var speed: float = 0.3

func animate_visuals(visuals: Sprite2D):
	if tween != null and tween.is_valid():
		return
	tween = visuals.create_tween()
	tween.tween_property(visuals, "rotation", 0.1, speed)
	tween.tween_property(visuals, "rotation", -0.1, speed)
	tween.finished.connect(func(_data): 
		animate_visuals(visuals)
	)

