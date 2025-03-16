shader_type canvas_item;

uniform float mix_strengh = 0.5;
uniform float opacity_speed = 1;
uniform float min_opacity = 0.2;
uniform float max_opacity = 0.5;
uniform vec4 color: source_color;

void fragment()
{
	float average = (max_opacity + min_opacity) / 2.0;
	float amplitude = (max_opacity - min_opacity) / 2.0;
	float wave = average + amplitude * sin(TIME * opacity_speed);
	float opacity = clamp(wave, min_opacity, max_opacity);
	COLOR.a = step(0.5, COLOR.a) * opacity;
	COLOR.rgb = mix(COLOR.rgb, color.rgb, mix_strengh);
}
