class_name PercentGenerator extends StatGenerator

@export var min_percentage: float = 5
@export var max_base_percentage: float = 10
@export var sample_curve: Curve

func generate_stats(wave_number: int) -> StatModifier:
	var area = valid_until_wave - valid_after_wave
	var percentage = float(wave_number) / area
	var multiplier = sample_curve.sample(percentage)

	var new_max = max_base_percentage * multiplier

	var modifier =  _get_template()
	modifier.value = randf_range(min_percentage, new_max)

	return modifier
	
