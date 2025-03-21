class_name LowestHp extends ThreatDetermination

func get_display_name() -> String:
	return tr("LOWEST_HP")

func get_threat(_tower: Node2D, enemies: Array[EntityWithStats]) -> EntityWithStats:
	var current_hp: float = 10000000
	var return_enemy: Enemy = null
	for enemy in enemies:
		if enemy.get_hp() < current_hp:
			current_hp = enemy.get_hp()
			return_enemy = enemy
	return return_enemy