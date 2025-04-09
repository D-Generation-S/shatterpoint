class_name ArmorIncreaseModifier extends StatModifier

func change_stats(base_stats: EntityStats, real_stats: EntityStats):
    base_stats.armor += value
    real_stats.armor += value