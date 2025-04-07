class_name HealPercentageModifier extends StatModifier

func change_stats(base_stats: EntityStats, real_stats: EntityStats):
    var heal_value = base_stats.max_hp * (value / 100)
    var current_hp = snapped(real_stats.hp + real_stats.max_hp * heal_value, 0.5)
    real_stats.hp = clampf(current_hp, 0, real_stats.max_hp)