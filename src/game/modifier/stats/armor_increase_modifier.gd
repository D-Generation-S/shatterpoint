class_name ArmorIncreaseModifier extends StatModifier

func change_stats(_base_stats: EntityStats, real_stats: EntityStats):
    real_stats.armor += value