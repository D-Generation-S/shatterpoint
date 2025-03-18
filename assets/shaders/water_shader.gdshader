shader_type canvas_item;

uniform vec4 mask_color: source_color;
uniform float mask_color_threshold= 0.001;
uniform vec4 water_color: source_color;
uniform vec4 water_top_color: source_color;
uniform float scale = 0.001;

uniform float movement_speed = 0.01;

uniform float caustic_mix: hint_range(0.1, 1.0, 0.01) = 0.5;
uniform float caustic_scale = 0.001;
uniform float caustic_movement_speed = 0.01;
uniform vec2 caustic_movement_direction = vec2(0.3, 0.4);
uniform vec4 caustic_color: source_color;
uniform sampler2D caustic_data: repeat_enable, filter_nearest;

uniform float wave_threshold = 0.4;
uniform sampler2D wave_noise_1: repeat_enable, filter_nearest;
uniform vec2 move_direction_1 = vec2(0.3,-0.5);

uniform sampler2D wave_noise_2: repeat_enable, filter_nearest;
uniform vec2 move_direction_2 = vec2(0.3,0.3);

varying vec2 world_position;

void vertex() {
	world_position = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
}

void fragment() {
	vec4 dist = abs(COLOR - mask_color);
	if (dist.r < mask_color_threshold
		&& dist.g < mask_color_threshold
		&& dist.b < mask_color_threshold)
	{
		vec2 movement_1 = move_direction_1 * TIME * movement_speed;
		vec4 noise_1 = texture(wave_noise_1, world_position * scale + movement_1);
		vec2 movement_2 = move_direction_2 * TIME * movement_speed;
		vec4 noise_2 = texture(wave_noise_2, world_position * scale + movement_2);
		
		vec2 celluar_movement = caustic_movement_direction * TIME * caustic_movement_speed;
		vec4 celluar = texture(caustic_data, world_position * caustic_scale + celluar_movement);
		celluar *= caustic_color;
		
		noise_1 = step(wave_threshold, noise_1);
		noise_2 = step(wave_threshold, noise_2);
		vec4 wave_top = noise_1 + noise_2;

		wave_top.r = 1. - wave_top.r;
		wave_top.g = 1. - wave_top.g;
		wave_top.b = 1. - wave_top.b;
		wave_top.a = wave_top.r;

		vec4 colored_wave_top = water_top_color * step(1, wave_top);
		vec4 base_water = mix(celluar, water_color, caustic_mix);
		COLOR = base_water + colored_wave_top;
	}
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
