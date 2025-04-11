shader_type canvas_item;

uniform vec4 rect_info = vec4(0, 48, 16, 16);

uniform sampler2D noise: repeat_enable, filter_nearest;
uniform float zoom: hint_range(0.0, 5, 0.0001) = 1;
uniform float percent_destroyed: hint_range(0.0, 1.0, 0.01) = 0.5;
uniform float alpha_threshold: hint_range(0.0, 1.0, 0.01) = 0.3;
uniform vec2 offset = vec2(0.0, 0.0);
uniform float solid_modifier: hint_range(1, 2.0, 0.01) = 1.5;

vec2 uv_to_region_uv(vec2 uv, vec2 texture_pixel_size)
{
	return (uv - (rect_info.xy * texture_pixel_size)) / (rect_info.zw * texture_pixel_size);
}
vec2 region_uv_to_uv(vec2 region_uv, vec2 texture_pixel_size)
{
	return rect_info.xy * texture_pixel_size + region_uv * (rect_info.zw * texture_pixel_size);
}

void fragment() {
	vec2 region_uv = uv_to_region_uv(UV, TEXTURE_PIXEL_SIZE);
	vec4 noise_texture = texture(noise, region_uv * vec2(zoom) + offset);
	float mix_value = step(percent_destroyed, region_uv.y);
	float upper_alpha = step(alpha_threshold, noise_texture.r) * ( 1.0 - mix_value) * COLOR.a;
	float target_alpha = COLOR.a * mix_value + upper_alpha;

	float gradient = (region_uv.y + 1.0 - percent_destroyed * solid_modifier) * step((1.0 - COLOR.a), region_uv.y);

	target_alpha = clamp(target_alpha, 0.0, 1.0);
	COLOR.a = target_alpha * gradient;
}

