class_name BuildingBase extends Resource

@export_group("Templates")
@export var death_animation: PackedScene = preload("res://scenes/game/particle/death_animations/building_destroyed.tscn")

@export_group("Resources")
@export var scrap_required: int = 3

@export_group("Visual")
@export var building_name: String
@export var texture: Texture2D
@export var input_color: Array[Color]
@export var output_color: Array[Color]

@export var stats: EntityStats