class_name PercentageDamageModifier extends StatModifier

func change_stats(base_stats: EntityStats, real_stats: EntityStats):
    var real_value = value / 100
    var stat_change = base_stats.damage * real_value
    real_stats.damage += stat_change