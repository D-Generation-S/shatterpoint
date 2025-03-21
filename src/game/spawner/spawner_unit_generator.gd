class_name SpawnerUnitGenerator extends Resource

@export var interval_factor_calculator: float = 4
@export var default_spawn_interval: float = 0.5

func generate_units_for_wave(_target_power: float, _possible_units: Array[UnitData]) -> SpawnInformation:
	return null
