class_name TowerData extends Resource

@export_category("Visual")
@export var texture: Texture2D
@export var input_color: Array[Color]
@export var ouput_color: Array[Color]

@export_category("Targeting")
@export var allowed_thread_determination: Array[ThreatDetermination]
@export var attackable_groups: Array[String]

@export var stats: EntityStats