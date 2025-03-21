extends Node

signal start_game()
signal enable_build_mode()
signal set_build_tool(tool: BuildModeTool)
signal add_new_message(target: int, message: String, time_to_show: float)
signal clear_message_area(target: int)
signal change_can_abort_building(on: bool)

@export var build_mode: BuildModeTool
@export var message_center: MessageCenter

func _ready():
	change_can_abort_building.emit(false)
	add_new_message.emit(MessagePosition.CENTER, "BUILD_GENERATOR_TO_START", 10)
	enable_build_mode.emit()
	set_build_tool.emit(build_mode)
	pass

func _start_game_now():
	change_can_abort_building.emit(true)
	set_build_tool.emit(null)
	clear_message_area.emit(MessagePosition.CENTER)
	start_game.emit()
	queue_free()