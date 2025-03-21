shader_type canvas_item;

uniform float mix_strengh = 0.5;
uniform float opacity_speed = 1;
uniform float min_opacity = 0.2;
uniform float max_opacity = 0.5;
uniform vec4 color: source_color;
uniform float number_of_scanlines = 90;
uniform float line_speed = 0.02;

void fragment()
{
	float average = (max_opacity + min_opacity) / 2.0;
	float amplitude = (max_opacity - min_opacity) / 2.0;
	float wave = average + amplitude * sin(TIME * opacity_speed);
	float opacity = clamp(wave, min_opacity, max_opacity);
	COLOR.a = step(0.5, COLOR.a) * opacity;

	vec2 new_uv = UV + TIME * line_speed;
	float scan = sin(new_uv.y * number_of_scanlines * PI * 2.0);
	vec4 scan_line = vec4(vec3(scan), opacity);
	vec3 base_color = mix(COLOR.rgb, color.rgb, mix_strengh);
	COLOR.rgb = mix(base_color.rgb, scan_line.rgb, 0.2);
}
