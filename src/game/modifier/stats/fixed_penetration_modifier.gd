class_name FixedPenetrationModifier extends StatModifier

func change_stats(base_stats: EntityStats, real_stats: EntityStats):
    base_stats.armor_penetration += value / 100
    real_stats.armor_penetration += value / 100