class_name ThreatDetermination extends Resource

func get_display_name() -> String:
    return "UNKNOWN"

func get_threat(_tower: Tower, _enemies: Array[Enemy]) -> Enemy:
    return null
