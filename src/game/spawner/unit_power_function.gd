class_name UnitPowerFunction extends Resource

@export var base_power: float = 100
@export_group("Linear growth")
@export var linear_base_value: float = 50

@export_group("Exponential growth")
@export var exponential_base: float = 1.8
@export var wave_to_start_exponential: int = 5

func get_target_power_for_units(wave_number: int, balance: float) -> float:
	var return_base = linear_calculation(wave_number) + calculate_exponential_grow(wave_number)
	return return_base * balance

	
func linear_calculation(wave_number: float) -> float:
	return linear_base_value * wave_number

func calculate_exponential_grow(wave_number: float) -> float:
	if wave_to_start_exponential < wave_number:
		return 0.0
	return pow(exponential_base, wave_number)
