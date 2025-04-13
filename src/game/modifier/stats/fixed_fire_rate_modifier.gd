class_name FireRateModifier extends StatModifier

func change_stats(base_stats: EntityStats, real_stats: EntityStats):
	base_stats.fire_rate -= value
	base_stats.fire_rate = clampf(base_stats.fire_rate, 0.1, 100000)

	real_stats.fire_rate -= value
	real_stats.fire_rate = clampf(real_stats.fire_rate, 0.1, 100000)
