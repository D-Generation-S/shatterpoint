class_name ButtonWithModifier extends Button

signal modifier_selected(modifier_data: StatModifier)

var modifier: StatModifier
var global_scrap: int = 0

func _ready():
	validate_if_enough_scrap()

func validate_if_enough_scrap() -> bool:
	return modifier.get_scrap_requirement() <= global_scrap

func global_scrap_updated(new_value: int):
	global_scrap = new_value
	validate_if_enough_scrap()

func _init(modifier_data: StatModifier, current_global_scrap: int):
	modifier = modifier_data
	global_scrap_updated(current_global_scrap)

	var value = snapped(modifier.get_value(), 0.01)

	text = "%s [%s] (%s)" % [modifier.get_display_name(),value, modifier.get_scrap_requirement()]
	var description = modifier.get_display_description() % value
	tooltip_text = description
	icon = modifier.get_display_icon()

	disabled = !validate_if_enough_scrap()

func _pressed():
	modifier_selected.emit(modifier)
