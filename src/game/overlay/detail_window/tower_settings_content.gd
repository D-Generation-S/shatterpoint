class_name TowerSettingContent extends DefaultDetailContent

signal threat_changed(threat: ThreatDetermination)
signal modification_added(modifier: StatModifier)

@export var thread_mode_dropdown: OptionButton
@export var modification_node: Control

var possible_selections: Array[ThreatDetermination]
var current_selection: int

func _ready():
	for selection in possible_selections:
		thread_mode_dropdown.add_item(selection.get_display_name())

	thread_mode_dropdown.selected = current_selection
	thread_mode_dropdown.item_selected.connect(selection_changed)

func selection_changed(index: int):
	threat_changed.emit(possible_selections[index])

func setup(threat_determinations: Array[ThreatDetermination],
		   possible_modifications: Array[StatModifier],
		   blocked: bool = false,
		   selection_index: int = 0):
	possible_selections = threat_determinations
	current_selection = selection_index

	for modification in possible_modifications:
		var button = ButtonWithModifier.new(modification, GlobalDataAccess.get_resource_overlay().get_scrap())
		
		GlobalDataAccess.get_resource_overlay().scrap_updated.connect(button.global_scrap_updated)

		button.modifier_selected.connect(_modifier_selected)
		if blocked:
			button.block_button()
		modification_node.add_child(button)

func _modifier_selected(modifier: StatModifier):
	for child in modification_node.get_children():
		if child is ButtonWithModifier:
			child.block_button()

	GlobalDataAccess.get_resource_overlay().add_scrap(-modifier.get_scrap_requirement())
	modification_added.emit(modifier)
