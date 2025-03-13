class_name EnemyData extends Resource

@export_group("Visual")
@export var texture: Texture2D
@export var input_color: Array[Color]
@export var ouput_color: Array[Color]

@export_group("Drops")
@export var min_scrap_drop: int = 0
@export var max_scrap_drop: int = 1

@export var stats: EntityStats