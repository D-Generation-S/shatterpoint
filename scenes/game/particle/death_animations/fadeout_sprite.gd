extends Sprite2D

signal fadeout_complete()

func _ready():
	if material is ShaderMaterial:
		material.set_shader_parameter("zoom", randf_range(0.2, 0.6))
		material.set_shader_parameter("percent_destroyed", randf_range(0.4, 0.6))
		material.set_shader_parameter("alpha_threshold", randf_range(0.3, 0.4))
		var texture_size = texture.get_size()
		var information = Vector4(0,0,texture_size.x, texture_size.y);
		if texture is AtlasTexture:
			var atlas_position = texture.region
			information.x = atlas_position.position.x
			information.y = atlas_position.position.y

		material.set_shader_parameter("rect_info", information)

func start_fadeout(time: float):
	var modulate_copy = modulate
	modulate_copy.a = 0
	var tween = create_tween()

	tween.tween_property(self, "modulate", modulate_copy, time / 2)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.finished.connect(_fadeout_done)

func _fadeout_done():
	fadeout_complete.emit()