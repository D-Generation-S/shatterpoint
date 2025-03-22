class_name FixedDamageModifier extends StatModifier

@export var value: float = 2

func change_stats(base_stats: EntityStats, real_stats: EntityStats):
    base_stats.damage += value
    real_stats.damage += value
