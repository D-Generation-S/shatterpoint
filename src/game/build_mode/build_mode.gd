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

@export var default_message_style: MessageStyle
@export var build_error_message_style: MessageStyle

@onready var tower_scene: PackedScene = load("res://scenes/game/templates/TowerTemplate.tscn")
@onready var build_grid: Node2D = $"%BuildGrid"

var current_building: TowerData
var build_mode_timer: Timer
var last_build_state: bool = true

var timer_shown: bool = false
var build_error_message: String

func _ready():
	build_mode_timer = Timer.new()
	build_mode_timer.wait_time = base_build_mode_time
	build_mode_timer.one_shot = true
	build_mode_timer.autostart = false
	build_mode_timer.timeout.connect(build_mode_endet)
	add_child(build_mode_timer)
	build_mode_timer.start()

	set_current_building(current_test_building)
	can_build_changed.emit(true)
	disable()

func _process(_delta):
	_handle_build_phase_warning()
	
	var all_buildings = get_tree().get_nodes_in_group(building_group) as Array[Node2D]
	var can_build = true
	if resource_overlay.get_scrap() < current_test_building.scrap_required:
			build_error_message = "NO_SCRAP_AVAILABLE"
			can_build = false

	for building in all_buildings:
		if building.global_position == build_grid.global_position:
			build_error_message = "BUILD_SPACE_BLOCKED"
			can_build = false

	if can_build != last_build_state:
		can_build_changed.emit(can_build)


	last_build_state = can_build

	if Input.is_action_just_pressed("interact"):
		if !can_build:
			message_requested.emit(MessagePosition.BOTTOM, build_error_message_style, build_error_message, 2)
			return
		var position = build_grid.global_position
		var template = tower_scene.instantiate() as Tower
		template.global_position = position
		template.tower_data = current_test_building
		template.add_to_group(building_group)
		building_target_nodes.add_child(template)
		resource_overlay.add_scrap(-current_test_building.scrap_required)
		
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
	process_mode = PROCESS_MODE_DISABLED
	build_grid.process_mode = build_grid.PROCESS_MODE_DISABLED
	build_grid.visible = false

func enable():
	process_mode = PROCESS_MODE_INHERIT
	build_grid.process_mode = build_grid.PROCESS_MODE_INHERIT
	build_mode_timer.start()
	build_grid.visible = true
	timer_shown = false
