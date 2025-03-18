class_name BuildMenuEntryTemplate extends Control

signal building_requested(build_data: TowerData)

@onready var _button: CustomTooltipTrigger = $"%Button"

var _entry_data: BuildMenuEntry

func _ready():
	_button.texture_normal = _entry_data.building_data.texture
	_button.tooltip_text = _entry_data.name
	_button.description = _entry_data.name + "_DESCRIPTION"

func setup(data: BuildMenuEntry):
	_entry_data = data

func pressed():
	building_requested.emit(_entry_data.building_data)