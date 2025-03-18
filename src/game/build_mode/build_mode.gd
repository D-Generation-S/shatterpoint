extends Node

signal change_ghost_texture(new_texture: Texture2D)
signal can_build_changed(can_build: bool)
signal build_mode_is_over()
signal message_requested(target: int, style: MessageStyle, message: String, duration: float, icon: Texture)

@export var resource_overlay: ResourceOverlay
@export var building_target_nodes: Node
@export var building_group: String = "building"
@export var current_test_building: TowerData
@export var base_build_mode_time: float = 30

@export var build_validators: Array[BuildValidator]

@export var default_message_style: MessageStyle
@export var build_error_message_style: MessageStyle

@onready var tower_scene: PackedScene = load("res://scenes/game/templates/TowerTemplate.tscn")
@onready var build_grid: Node2D = $"%BuildGrid"

var current_building: TowerData
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
	if event.is_action("interact") and Input.is_action_just_pressed("interact"):
		print("interacting")
		if !can_build_here:
			message_requested.emit(MessagePosition.BOTTOM, build_error_message_style, cannot_build_message, 2)
			return
		var position = build_grid.global_position
		var template = tower_scene.instantiate() as Tower
		template.global_position = position
		template.tower_data = current_building
		template.add_to_group(building_group)
		building_target_nodes.add_child(template)
		resource_overlay.add_scrap(-current_building.scrap_required)

func _process(_delta):
	_check_for_building_abort()
	if !_check_for_building():
		return
	_handle_build_phase_warning()
	
	
	var can_build = true
	var resource_data = resource_overlay.get_resource_data()
	var message: String = ""
	for build_validator in build_validators:
		var validation_return = build_validator.is_valid(get_tree(), build_grid.global_position, current_building, resource_data)
		can_build = validation_return.get_can_build()
		message = validation_return.get_error_message()
		if !can_build:
			break

	if can_build != last_build_state:
		can_build_changed.emit(can_build)
	last_build_state = can_build
	

	can_build_here = can_build
	cannot_build_message = message

func _check_for_building_abort():
	if Input.is_action_just_pressed("ui_cancel"):
		current_building = null

func _check_for_building() -> bool:
	if current_building == null:
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

func set_current_building(building_data: TowerData):
	current_building = building_data
	change_ghost_texture.emit(building_data.texture)

func disable():
	in_build_mode = false
	current_building = null
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