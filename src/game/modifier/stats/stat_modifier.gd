class_name StatModifier extends Resource

@export var priority: int = 10000

func change_stats(_base_stats: EntityStats, real_stats: EntityStats):
    return real_stats
