class_name ColorReplaceShader extends Sprite2D

func set_color_replacement(input_colors: Array[Color], output_colors: Array[Color]):
	if input_colors.size() != output_colors.size():
		printerr("Input color size is not equal to output color size!")
		return

	if material is ShaderMaterial:
		material.set_shader_parameter("base_colors", input_colors)
		material.set_shader_parameter("target_colors", output_colors)
		material.set_shader_parameter("set_colors", output_colors.size())
		

func convert_colors_to_vec4(colors: Array[Color]):
	return colors.map(convert_colors_to_vec4)

func convert_color_to_vec4(color: Color) -> Vector4:
	return Vector4(color.r, color.g, color.b, color.a)