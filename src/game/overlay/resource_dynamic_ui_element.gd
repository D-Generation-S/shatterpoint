@tool
extends ResourceUiElement

signal max_value_has_changed(amount: float)

func set_max_value(amount: float):
	max_value_has_changed.emit(amount)
