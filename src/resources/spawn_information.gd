class_name SpawnInformation extends Resource

@export var spawn_sets: Array[SpawnSet]
@export var spawn_interval_in_seconds: float = 0.5

func _init(sets: Array[SpawnSet], interval_in_seconds: float):
    spawn_sets = sets
    spawn_interval_in_seconds = interval_in_seconds