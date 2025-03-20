class_name TowerData extends BuildingBase

@export_group("Targeting")
@export var allowed_thread_determination: Array[ThreatDetermination]
@export var attackable_groups: Array[String]
@export var projectile: PackedScene

@export var power_usage_per_shot: float = 1

@export var stats: EntityStats