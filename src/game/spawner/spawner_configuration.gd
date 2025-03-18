class_name SpawnerConfiguration extends Resource

@export var power_function: UnitPowerFunction
@export var generator: SpawnerUnitGenerator
@export var possible_data: Array[EnemyData]

var _balance: float = 1

func set_balance(balance: float):
	_balance = balance

func generate_unit_set(wave_number: int)  -> SpawnInformation:
	var target_power = power_function.get_target_power_for_units(wave_number, _balance)
	var allowed_data_sets = possible_data.filter(func(data_set): return data_set.min_wave_requirement <= wave_number)
	return generator.generate_units_for_wave(target_power, allowed_data_sets)