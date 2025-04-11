class_name SpecialModifierConfiguration extends Resource

## How often this will be added to the loot table for selection
@export_range(0, 10000, 0.001) var probability: int = 1
@export_flags("Unit", "Tower", "Generator", "Scrap Storage", "Unit Spawner") var scope: int
@export var modifier: StatModifier
@export var permanent: bool = true
@export var selectable_after_wave: int = 0
@export_file("*.tres") var modifier_requirements: Array[String]