extends CanvasLayer

signal scrap_updated(new_value: int)

@export var max_scrap: int = 99999

var current_scrap: int = 0

func _ready():
	scrap_updated.emit(current_scrap)


func add_scrap(value: int):
	current_scrap += value
	clampi(current_scrap, 0, max_scrap)
	scrap_updated.emit(current_scrap)
	