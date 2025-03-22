class_name ThreatDetermination extends Resource

func get_display_name() -> String:
    return "UNKNOWN"

func get_threat(_tower: Node2D, _enemies: Array[EntityWithStats]) -> EntityWithStats:
    return null
