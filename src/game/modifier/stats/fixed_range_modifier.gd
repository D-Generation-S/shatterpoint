class_name FixedRangeModifier extends StatModifier

func change_stats(base_stats: EntityStats, real_stats: EntityStats):
    base_stats.attack_range += value
    real_stats.attack_range += value