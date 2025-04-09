shader_type canvas_item;

uniform vec4 rect_info = vec4(0, 48, 16, 16);

uniform float progress: hint_range(0.0, 1.0, 0.001) = 0.0;

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
	float cut_left = step(progress / 2.0, region_uv.x);
	float cut_right = 1.0 - step(1.0 - progress / 2.0 ,region_uv.x);
	
	COLOR.a = cut_left  * cut_right * COLOR.a;
}