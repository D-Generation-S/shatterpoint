@tool
extends ResourceUiElement

signal hide_bar()
signal show_bar()

func set_max_value(amount: int):
	super(amount)
		
	if amount > 0:
		show_bar.emit()
	else:
		value_changed.emit(amount)
		hide_bar.emit()

