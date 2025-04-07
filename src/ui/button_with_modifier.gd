class_name ButtonWithModifier extends Button

signal modifier_selected(modifier_data: StatModifier)

var modifier: StatModifier
var global_scrap: int = 0

var _was_blocked: bool = false

func _ready():
	_self_validate_now()

func _is_enough_scrap_in_storage() -> bool:
	return modifier.get_scrap_requirement() <= global_scrap

func global_scrap_updated(new_value: int):
	global_scrap = new_value
	_self_validate_now()

func _init(modifier_data: StatModifier, current_global_scrap: int):
	modifier = modifier_data
	global_scrap_updated(current_global_scrap)

	var value = snapped(modifier.get_value(), 0.01)

	text = "%s [%s] (%s)" % [tr(modifier.get_display_name()),value, modifier.get_scrap_requirement()]
	var description = tr(modifier.get_display_description()) % value
	tooltip_text = description
	expand_icon = true
	custom_minimum_size = Vector2(0, 32)
	icon = modifier.get_display_icon()

	_self_validate_now()

func _self_validate_now():
	disabled = _was_blocked || !_is_enough_scrap_in_storage()

func block_button():
	_was_blocked = true
	disabled = _was_blocked

func _pressed():
	modifier_selected.emit(modifier)
