extends Node

signal change_ghost_texture(new_texture: Texture2D)
signal can_build_changed(can_build: bool)
signal message_requested(target: int, style: MessageStyle, message: String, duration: float, icon: Texture)
signal request_path(icon: Texture, start_node: Node2D, end_node: Node2D, amount: int, time: float)

signal building_was_placed()

@export var resource_overlay: ResourceOverlay
@export var building_target_node: Node
@export var building_group: String = "building"

@export var scrap_resource_trave_node: Node2D
@export var resource_path_template: PackedScene

@export var default_message_style: MessageStyle
@export var build_error_message_style: MessageStyle

@onready var build_grid: Node2D = $"%BuildGrid"

var current_tool: BuildModeTool = null
var in_build_mode: bool = false
var last_build_state: bool = true

var can_build_here: bool = false
var cannot_build_message: String = ""
var can_abort_building: bool = true

func _ready():
	can_build_changed.emit(true)
	disable()

func _unhandled_input(event):
	if current_tool != null and event.is_action("interact") and Input.is_action_just_pressed("interact"):
		if !can_build_here:
			message_requested.emit(MessagePosition.BOTTOM, build_error_message_style, cannot_build_message, 2)
			return
		var build_position = build_grid.global_position
		var building = null
		var buildings = get_tree().get_nodes_in_group(building_group).filter(func(current_building): return current_building.global_position == build_position)
		if buildings.size() > 0:
			building = buildings[0]
		var scrap = current_tool.execute(build_position, building, building_target_node)

		var source_node = scrap_resource_trave_node
		var end_node: Node2D = Node2D.new()
		end_node.position = build_position
		if scrap > 0:
			end_node.global_position = building.global_position
			source_node = end_node
			end_node = scrap_resource_trave_node
			
		request_path.emit(resource_overlay.scrap_icon, source_node, end_node, absi(scrap), 1)
		building_was_placed.emit()
		resource_overlay.add_scrap(scrap)

func _process(_delta):
	_check_for_building_abort()
	if !_check_for_building():
		return
	
	
	var resource_data = resource_overlay.get_resource_data()
	var validator = current_tool.can_be_used(get_tree(), build_grid.global_position, resource_data)

	if validator.get_can_build() != last_build_state:
		can_build_changed.emit(validator.get_can_build())
	last_build_state = validator.get_can_build()
	

	can_build_here = validator.get_can_build()
	cannot_build_message = validator.get_error_message()

func _check_for_building_abort():
	if Input.is_action_just_pressed("ui_cancel"):
		if !can_abort_building:
			message_requested.emit(MessagePosition.BOTTOM, build_error_message_style, "CANT_ABORT_BUILDING_RIGHT_NOW", 2)
			return
		current_tool = null

func _check_for_building() -> bool:
	if current_tool == null:
		build_grid.visible = false
		return false
	build_grid.visible = true
	return true

func set_current_tool(building_tool: BuildModeTool):
	if building_tool == null:
		current_tool = null
		return
	current_tool = building_tool
	change_ghost_texture.emit(current_tool.get_ghost_icon())

func disable():
	in_build_mode = false
	process_mode = PROCESS_MODE_DISABLED
	build_grid.process_mode = build_grid.PROCESS_MODE_DISABLED
	build_grid.visible = false

func enable():
	in_build_mode = true
	process_mode = PROCESS_MODE_INHERIT
	build_grid.process_mode = build_grid.PROCESS_MODE_INHERIT
	build_grid.visible = true

func mouse_on_menu():
	process_mode = PROCESS_MODE_DISABLED
	build_grid.process_mode = build_grid.PROCESS_MODE_DISABLED
	build_grid.visible = false

func mouse_off_menu():
	if !in_build_mode:
		return
	process_mode = PROCESS_MODE_INHERIT
	build_grid.process_mode = build_grid.PROCESS_MODE_INHERIT
	build_grid.visible = true

func allow_build_abort(on: bool):
	can_abort_building = on