extends CanvasLayer

signal build_tool_selected(building_tool: BuildModeTool)
signal build_mode_open()
signal build_mode_close()
signal hover_over_build_menu()
signal no_hover_over_build_menu()

@export var _menu_data: Array[BuildMenuGroup]

@export var build_group_template: PackedScene

@onready var group_node: Control = $"%Groups"
@onready var exit_timer: Timer = $"ExitTimer"

var build_mode: bool = false

func _ready():
	for group in _menu_data:
		_add_build_group(group)
	is_enabled()
	group_node.visible = false
	exit_timer.timeout.connect(communicate_hover_exit)

func _add_build_group(group: BuildMenuGroup):
	var template = build_group_template.instantiate() as BuildMenuGroupEntry
	template.setup(group)
	template.building_selected.connect(func(data): build_tool_selected.emit(data))
	template.mouse_entered.connect(hover_enter)
	template.mouse_exited.connect(hover_exit)
	group_node.add_child(template)

func was_pressed():
	build_mode = !build_mode
	if build_mode:
		build_mode_open.emit()
	else:
		build_mode_close.emit()

func is_enabled():
	visible = true

func is_disabled():
	visible = false
	build_mode = false
	group_node.visible = false
	build_mode_close.emit()

func hover_enter():
	exit_timer.stop()
	hover_over_build_menu.emit()

func hover_exit():
	exit_timer.start()

func communicate_hover_exit():
	no_hover_over_build_menu.emit()