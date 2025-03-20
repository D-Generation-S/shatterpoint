class_name HighestHp extends ThreatDetermination

func get_display_name() -> String:
	return tr("MOST_HP")

func get_threat(_tower: Tower, enemies: Array[Enemy]) -> Enemy:
	var current_hp: float = -1
	var return_enemy: Enemy = null
	for enemy in enemies:
		if enemy.get_hp() > current_hp:
			current_hp = enemy.get_hp()
			return_enemy = enemy
	return return_enemy
