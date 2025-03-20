class_name UnitPowerFunction extends Resource

@export var base_power: float = 100

func get_target_power_for_units(wave_number: int, balance: float) -> float:
	return pow(1.8, wave_number) + base_power * balance