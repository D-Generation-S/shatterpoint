class_name FixedGenerator extends StatGenerator

@export var min_value: float = 1
@export var max_base_value: float = 4
@export var sample_curve: Curve

func generate_stats(wave_number: int) -> StatModifier:
	var area = valid_until_wave - valid_after_wave
	var percentage = float(wave_number) / area
	var multiplier = sample_curve.sample(percentage)

	var new_max = max_base_value * multiplier

	var modifier =  _get_template()
	modifier.value = randf_range(min_value, new_max)

	return modifier
	