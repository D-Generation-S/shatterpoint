class_name Enemy extends EntityWithStats


func get_hp() -> float:
	return stats.hp

func deal_damage(points: float):
	stats.hp = stats.hp - points
	if stats.hp <= 0:
		queue_free()
