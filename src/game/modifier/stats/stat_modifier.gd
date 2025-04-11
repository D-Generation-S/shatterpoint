class_name StatModifier extends Resource

@export var _name: String
@export var _icon: Texture
@export var _scrap_cost: int = 1
@export var priority: int = 10000
@export var one_time_usage: bool = false

@export var value: float

func change_stats(_base_stats: EntityStats, real_stats: EntityStats):
    return real_stats

func get_scrap_requirement() -> int:
    return _scrap_cost

func get_display_name() -> String:
    return _name

func get_display_description() -> String:
    return _name + "_DESCRIPTION"

func get_display_icon() -> Texture:
    return _icon

func get_value() -> float:
    return value