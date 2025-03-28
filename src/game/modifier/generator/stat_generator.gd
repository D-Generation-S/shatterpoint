class_name StatGenerator extends Resource

@export_group("Validation")
@export var valid_after_wave: int = 0
@export var valid_until_wave: int = 100


@export var modifier_template: StatModifier

func is_valid(wave_number: int) -> bool:
	return wave_number >= valid_after_wave && wave_number <= valid_until_wave

func _get_template() -> StatModifier:
	return modifier_template.duplicate()

func generate_stats(_wave_number: int) -> StatModifier:
	return null
