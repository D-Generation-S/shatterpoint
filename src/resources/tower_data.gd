class_name TowerData extends Resource

@export_group("Resources")
@export var scrap_required: int = 3

@export_group("Visual")
@export var texture: Texture2D
@export var input_color: Array[Color]
@export var ouput_color: Array[Color]

@export_group("Targeting")
@export var allowed_thread_determination: Array[ThreatDetermination]
@export var attackable_groups: Array[String]
@export var projectile: PackedScene

@export var stats: EntityStats