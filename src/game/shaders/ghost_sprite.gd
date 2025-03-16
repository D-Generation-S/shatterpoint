extends Sprite2D

@export var can_build_color: Color
@export var can_not_build_color: Color

func can_build_changed(can_build: bool):
	if can_build:
		_change_color(can_build_color)
	else:
		_change_color(can_not_build_color)

func _change_color(target_color: Color):
	if material is ShaderMaterial:
		material.set_shader_parameter("color", target_color)
	pass