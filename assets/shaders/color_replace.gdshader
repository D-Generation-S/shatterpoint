shader_type canvas_item;

uniform vec4 base_colors[5] : source_color;
uniform vec4 target_colors[5] : source_color;
uniform int set_colors;
uniform float threshold = 0.001;


void fragment()
{
	for(int i = 0; i < set_colors; i++)
	{
		vec4 dist = abs(COLOR - base_colors[i]);
		if (dist.r < threshold
			&& dist.g < threshold
			&& dist.b < threshold
			&& dist.a < threshold)
		{
			COLOR = target_colors[i];
		}
	} 
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
