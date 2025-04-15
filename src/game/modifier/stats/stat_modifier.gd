class_name StatModifier extends Resource

@export var _name: String
@export var _icon: Texture
@export var _scrap_cost: int = 1
## Modifiers which increase a flat value, should get a lower priority
@export var priority: int = 10000
@export var one_time_usage: bool = false
@export var projectile_modifier: bool = false
@export var _tags: Array[Tag]

@export var value: float

var valid: bool = true
var _sorted: bool = false

## Method to run once if a modifier was selected, this can be used for special modifiers to do global changes
func modifier_selected():
	pass

## Change stat every tick, can be used for effects over time
func tick_stat_change(_real_stats: EntityStats):
	pass

func change_stats(_base_stats: EntityStats, _real_stats: EntityStats):
	pass

## Is this modifier valid, if not it should not change any stats
func is_valid() -> bool:
	return valid

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

func get_tags() -> Array[Tag]:
	if !_sorted:
		_tags.sort_custom(_sort_tags)
		_sorted = true
	return _tags

func _sort_tags(a: Tag, b: Tag) -> bool:
	return tr(a.get_display_name()) < tr(b.get_display_name())