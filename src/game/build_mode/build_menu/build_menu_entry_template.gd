class_name BuildMenuEntryTemplate extends Control

signal building_requested(build_tool: BuildModeTool)
signal icon_changed(texture: Texture)

@onready var _button: CustomTooltipTrigger = $"%Button"

var _entry_data: BuildMenuEntry

func _ready():
	icon_changed.emit(_entry_data.icon)
	_button.tooltip_key = _entry_data.get_building_name()
	#_button.texture_normal = _entry_data.icon
	#_button.tooltip_text = _entry_data.get_building_name()
	#_button.description = _entry_data.get_building_description()

func setup(data: BuildMenuEntry):
	_entry_data = data

func pressed():
	building_requested.emit(_entry_data.building_data)
