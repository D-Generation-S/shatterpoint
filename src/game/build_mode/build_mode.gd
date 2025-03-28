extends Node2D

signal change_ghost_texture(new_texture: Texture2D)
signal can_build_changed(can_build: bool)
signal message_requested(target: int, style: MessageStyle, message: String, duration: float, icon: Texture)
signal request_path(icon: Texture, start_node: Node2D, end_node: Node2D, amount: int, time: float)

signal trying_to_place_building()
signal stopped_trying_to_place_building()
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

var last_global_position: Vector2
var draw_turret_range: bool
var draw_range: float = 0

func _ready():
	can_build_changed.emit(true)
	disable()
	draw_turret_range = false

	for build_area in get_tree().get_nodes_in_group("build_area_collision"):
		if build_area is CollisionAreaWithOverlay:
			trying_to_place_building.connect(build_area.show_drawing)
			stopped_trying_to_place_building.connect(build_area.hide_drawing)

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
		last_global_position = Vector2(-100000, -100000)

func _process(_delta):
	if draw_turret_range:
		queue_redraw()
	_check_for_building_abort()
	if !_check_for_building():
		return
	var build_position = build_grid.global_position
	if last_global_position == build_position:
		return
	var building = null
	var buildings = get_tree().get_nodes_in_group(building_group).filter(func(current_building): return current_building.global_position == build_position)
	if buildings.size() > 0:
		building = buildings[0]
	
	var resource_data = resource_overlay.get_resource_data()
	var validator = current_tool.can_be_used(get_tree(), building, build_grid.global_position, resource_data)

	if validator.get_can_build() != last_build_state:
		can_build_changed.emit(validator.get_can_build())
	last_build_state = validator.get_can_build()
	

	can_build_here = validator.get_can_build()
	cannot_build_message = validator.get_error_message()

	last_global_position = build_position

func _check_for_building_abort():
	if Input.is_action_just_pressed("ui_cancel"):
		if !can_abort_building:
			message_requested.emit(MessagePosition.BOTTOM, build_error_message_style, "CANT_ABORT_BUILDING_RIGHT_NOW", 2)
			return
		set_current_tool(null)

func _check_for_building() -> bool:
	if current_tool == null:
		build_grid.visible = false
		return false
	build_grid.visible = true
	return true

func set_current_tool(building_tool: BuildModeTool):
	if building_tool == null:
		current_tool = null
		draw_turret_range = false
		queue_redraw()
		stopped_trying_to_place_building.emit()
		return
	current_tool = building_tool
	if current_tool is BuildingConstruction:
		trying_to_place_building.emit()
		draw_turret_range = false
		if current_tool.building_data.stats.attack_range > 0:
			draw_range = current_tool.building_data.stats.attack_range
			draw_turret_range = true
		
		queue_redraw()
	else:
		draw_turret_range = false
		stopped_trying_to_place_building.emit()
		queue_redraw()
	change_ghost_texture.emit(current_tool.get_ghost_icon())

func disable():
	set_current_tool(null)
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

func _draw():
	if !draw_turret_range:
		return

	draw_circle(build_grid.global_position, draw_range, Color(1,0,0,0.2))