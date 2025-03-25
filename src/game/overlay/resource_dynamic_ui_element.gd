@tool
extends ResourceUiElement

signal max_value_has_changed(amount: float)
signal hide_bar()
signal show_bar()

func set_max_value(amount: float):
	max_value_has_changed.emit(amount)
		
	if amount > 0:
		show_bar.emit()
	else:
		value_changed.emit(amount)
		hide_bar.emit()

