class_name BuildMenuGroupEntry extends Control

signal building_selected(building_tool: BuildModeTool)

@export var entry_target_node: Control
@export var build_menu_entry_template: PackedScene

@onready var _button: CustomTooltipTrigger = $"%ActivationButton"

var _group_data: BuildMenuGroup

var _active: bool = false

func _ready():
	if _group_data.entries.size() == 0:
		queue_free()
	build_menu_inactive()
	_button.texture_normal = _group_data.icon
	_button.tooltip_text = _group_data.name
	_button.description = _group_data.name + "_DESCRIPTION"
	for entry in _group_data.entries:
		_add_entry(entry)

func _add_entry(entry: BuildMenuEntry):
	var template = build_menu_entry_template.instantiate() as BuildMenuEntryTemplate
	template.setup(entry)
	template.building_requested.connect(func(data): building_selected.emit(data))
	entry_target_node.add_child(template)

func setup(data: BuildMenuGroup):
	_group_data = data

func build_menu_active():
	entry_target_node.visible = true

func build_menu_inactive():
	entry_target_node.visible = false

func pressed():
	_active = !_active
	entry_target_node.visible = _active
