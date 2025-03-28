extends Node

signal start_game()
signal enable_build_mode()
signal set_build_tool(tool: BuildModeTool)
signal add_new_message(target: int, message: String, time_to_show: float)
signal clear_message_area(target: int)
signal change_can_abort_building(on: bool)

@export var scrap_storage_build_mode: BuildModeTool
@export var generator_build_mode: BuildModeTool
@export var message_center: MessageCenter

@export var start_scrap: int = 35

var added_buildings: int = 0
var overlay: ResourceOverlay

func _ready():
	GlobalMessageLine.building_added.connect(_building_was_placed)
	GlobalDataAccess.game_started()
	overlay = GlobalDataAccess.get_resource_overlay()
	change_can_abort_building.emit(false)
	add_new_message.emit(MessagePosition.CENTER, "BUILD_SCRAP_STORAGE_TO_START", 10)
	enable_build_mode.emit()
	set_build_tool.emit(scrap_storage_build_mode)

func _building_was_placed(_building: Building):
	added_buildings += 1
	clear_message_area.emit(MessagePosition.CENTER)
	set_build_tool.emit(null)
	if added_buildings == 1:
		overlay.add_scrap(start_scrap)
	
		add_new_message.emit(MessagePosition.CENTER, "BUILD_GENERATOR_NEXT", 10)
		set_build_tool.emit(generator_build_mode)
		return

	_start_game_now()


func _start_game_now():
	change_can_abort_building.emit(true)
	set_build_tool.emit(null)
	clear_message_area.emit(MessagePosition.CENTER)
	start_game.emit()
	queue_free()