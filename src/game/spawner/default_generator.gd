class_name DefaultGenerator extends SpawnerUnitGenerator

var randomizer: RandomNumberGenerator

func _init(randomizer_seed: int = -1):
	if randomizer_seed == -1:
		randomizer_seed = randi()

	randomizer = RandomNumberGenerator.new()
	randomizer.seed = randomizer_seed


func generate_units_for_wave(target_power: float, possible_units: Array[UnitData]) -> SpawnInformation:
	var current_power: float = 0
	var spawn_speed: float = randomizer.randf_range(0.5, interval_factor_calculator)
	var spawn_speed_multiplier: float = interval_factor_calculator / spawn_speed
	var spawn_sets: Array[SpawnSet] = []

	while (current_power < target_power):
		var allowed_units = possible_units.filter(func(unit): return unit.get_power_number() < target_power)
		if allowed_units.size() == 0:
			print("No more units to spawn")
			break
		var current_unit = allowed_units[randomizer.randi_range(0, allowed_units.size() - 1)]
		var existing_sets = spawn_sets.filter(func(_set): return _set.enemy_data == current_unit)
		var current_set = null
		if existing_sets.size() == 0:
			current_set = SpawnSet.new()
			current_set.enemy_data = current_unit
			spawn_sets.append(current_set)
		else:
			current_set = existing_sets[0]

		current_set.amount += 1
		current_power += current_unit.get_power_number() * spawn_speed_multiplier
	return SpawnInformation.new(spawn_sets, spawn_speed)