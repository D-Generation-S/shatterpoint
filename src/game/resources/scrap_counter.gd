class_name ScrapCounter extends Node

signal scrap_changed(value: int)

var current_scrap: int = 0

func update_scrap(new_value: int):
	scrap_changed.emit(new_value)
