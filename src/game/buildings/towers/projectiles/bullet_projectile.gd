class_name BulletProjectile extends Projectile


@export var final_scale: float = 0.2
@export var impact_texture: Array[Texture]

var point: Vector2

var tween: Tween

func _start_live_time_animation(time_to_live: float, visuals: Sprite2D):
	tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(visuals, "scale", Vector2(final_scale, final_scale), time_to_live)
	pass

func _calculate_impact_point(target: EntityWithStats) -> Vector2:
	var distance = target.global_position.distance_to(global_position)
	var time_for_hit = distance / speed
	var target_velocity = Vector2.ZERO
	if target is Enemy:
		target_velocity = target.get_velocity()
	var aim_point = target.global_position + target_velocity * time_for_hit
	return aim_point

func _trigger_lifetime_end_effect(current_position):
	super(current_position)
	if impact_texture.size() == 0:
		return

	sticker_requested.emit(current_position, impact_texture.pick_random())
