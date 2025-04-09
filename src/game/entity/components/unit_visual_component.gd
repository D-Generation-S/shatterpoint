extends Sprite2D

@export var animation_threshold: float = 0.05
## Duration is hide and show, each part will be half of this time.
@export var animation_duration: float = 0.25

var animation: EntityAnimation
var flip_tween: Tween
var target_h_flip: bool = false

func data_changed(data: UnitData):
	if data.animation == null:
		return
	_update_texture(data.texture)
	
	animation = data.animation.duplicate()

func _update_texture(new_texture: Texture):
	texture = new_texture
	if material is ShaderMaterial:
		material.set_shader_parameter("progress", 0)
		var texture_size = texture.get_size()
		var information = Vector4(0,0,texture_size.x, texture_size.y);
		if texture is AtlasTexture:
			var atlas_position = texture.region
			information.x = atlas_position.position.x
			information.y = atlas_position.position.y

		material.set_shader_parameter("rect_info", information)

func velocity_changed(new_velocity: Vector2):
	if new_velocity.x < 0:
		_animate_flip(true)
	else:
		_animate_flip(false)

	if animation == null:
		return

	if new_velocity.distance_to(Vector2.ZERO) > animation_threshold:
		animation.animate_visuals(self)
	else:
		animation.kill_animation()

func _animate_flip(flip_state: bool):
	if flip_state == target_h_flip:
		return
	if flip_tween != null and flip_tween.is_valid():
		flip_tween.kill()
	target_h_flip = flip_state

	flip_tween = create_tween()
	flip_tween.step_finished.connect(func(step_id): _step_completed(step_id, flip_state))
	flip_tween.tween_method(_animate_shader_progress, 0.0, 1.0, animation_duration / 2)
	flip_tween.tween_method(_animate_shader_progress, 1.0, 0.0, animation_duration / 2)

func _step_completed(id: int, flip_state):
	if id == 0:
		flip_h = flip_state

func _animate_shader_progress(value: float):
	if material is ShaderMaterial:
		material.set_shader_parameter("progress", value)