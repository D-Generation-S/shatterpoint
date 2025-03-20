extends Node

signal change_ghost_texture(new_texture: Texture2D)
signal can_build_changed(can_build: bool)
signal build_mode_is_over()
signal message_requested(target: int, style: MessageStyle, message: String, duration: float, icon: Texture)
signal request_path(icon: Texture, start_node: Node2D, end_node: Node2D, amount: int, time: float)

@export var resource_overlay: ResourceOverlay
@export var building_target_node: Node
@export var building_group: String = "building"
@export var base_build_mode_time: float = 30

@export var scrap_resource_trave_node: Node2D
@export var resource_path_template: PackedScene

@export var default_message_style: MessageStyle
@export var build_error_message_style: MessageStyle

@onready var build_grid: Node2D = $"%BuildGrid"

var current_tool: BuildModeTool = null
var in_build_mode: bool = false
var build_mode_timer: Timer
var last_build_state: bool = true

var timer_shown: bool = false
var can_build_here: bool = false
var cannot_build_message: String = ""

func _ready():
	build_mode_timer = Timer.new()
	build_mode_timer.wait_time = base_build_mode_time
	build_mode_timer.one_shot = true
	build_mode_timer.autostart = false
	build_mode_timer.timeout.connect(build_mode_endet)
	add_child(build_mode_timer)
	build_mode_timer.start()

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

		resource_overlay.add_scrap(scrap)

func _process(_delta):
	_check_for_building_abort()
	if !_check_for_building():
		return
	_handle_build_phase_warning()
	
	
	var resource_data = resource_overlay.get_resource_data()
	var validator = current_tool.can_be_used(get_tree(), build_grid.global_position, resource_data)

	if validator.get_can_build() != last_build_state:
		can_build_changed.emit(validator.get_can_build())
	last_build_state = validator.get_can_build()
	

	can_build_here = validator.get_can_build()
	cannot_build_message = validator.get_error_message()

func _check_for_building_abort():
	if Input.is_action_just_pressed("ui_cancel"):
		current_tool = null

func _check_for_building() -> bool:
	if current_tool == null:
		build_grid.visible = false
		return false
	build_grid.visible = true
	return true

func _handle_build_phase_warning():
	if build_mode_timer.time_left < 6 and not timer_shown:
		var message = tr("BUILD_TIME_LEFT")
		var time_left: int = build_mode_timer.time_left
		message = message.replace("%TIME%", str(time_left))
		message_requested.emit(MessagePosition.CENTER, default_message_style, message, 2)
		timer_shown = true

func build_mode_endet():
	build_mode_is_over.emit()

func set_current_tool(building_tool: BuildModeTool):
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
	build_mode_timer.start()
	build_grid.visible = true
	timer_shown = false

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
