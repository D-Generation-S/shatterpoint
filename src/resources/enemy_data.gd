class_name EnemyData extends Resource

@export_group("Visual")
@export var texture: Texture2D
@export var input_color: Array[Color]
@export var ouput_color: Array[Color]

@export_group("Drops")
@export var min_scrap_drop: int = 0
@export var max_scrap_drop: int = 1

@export_group("Difficulty")
@export var min_wave_requirement: int = 1
@export var stats: EntityStats

func get_power_number() -> float:
    var return_data: float = stats.hp
    return_data += stats.armor * 1.3
    return_data -= (min_scrap_drop + max_scrap_drop) / 2.0
    return_data += stats.damage * 2
    return_data += 4 / stats.fire_rate 
    return return_data