class_name BulletProjectile extends Projectile

@export var final_scale: float = 0.2

var point: Vector2

var tween: Tween

func _start_live_time_animation(time_to_live: float, visuals: Sprite2D):
	print("animate")
	tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(visuals, "scale", Vector2(final_scale, final_scale), time_to_live)
	pass

func _calculate_impact_point(target: EntityWithStats) -> Vector2:
	var distance = target.global_position.distance_to(global_position)
	var time_for_hit = distance / speed
	var aim_point = target.global_position + target.get_velocity() * time_for_hit
	return aim_point
	