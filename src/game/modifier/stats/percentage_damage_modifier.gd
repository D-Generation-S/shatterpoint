class_name PercentageDamageModifier extends StatModifier

@export var percentage: float = 0

func change_stats(base_stats: EntityStats, real_stats: EntityStats):
    var real_value = percentage / 100
    var stat_change = base_stats.damage * real_value
    real_stats.damage += stat_change
