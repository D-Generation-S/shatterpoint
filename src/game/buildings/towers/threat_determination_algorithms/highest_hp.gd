class_name HighestHp extends ThreatDetermination

func get_display_name() -> String:
	return tr("MOST_HP")

func get_threat(_tower: Node2D, enemies: Array[EntityWithStats]) -> EntityWithStats:
	var current_hp: float = -1
	var return_enemy: EntityWithStats = null
	for enemy in enemies:
		if enemy.get_hp() > current_hp:
			current_hp = enemy.get_hp()
			return_enemy = enemy
	return return_enemy
