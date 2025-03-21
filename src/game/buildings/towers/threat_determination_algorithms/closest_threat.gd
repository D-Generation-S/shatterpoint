class_name ClosestThreat extends ThreatDetermination

func get_display_name() -> String:
	return tr("CLOSEST_ENEMY")

func get_threat(tower: Node2D, enemies: Array[EntityWithStats]) -> EntityWithStats:
	var closest: EntityWithStats = null
	var closest_distance: float = 5000000
	for enemy in enemies:
		var distance = tower.global_position.distance_to(enemy.global_position)
		if distance < closest_distance:
			closest_distance = distance
			closest = enemy
	return closest
