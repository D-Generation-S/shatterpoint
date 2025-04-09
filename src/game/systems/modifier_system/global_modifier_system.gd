class_name ModifierSystem extends Node

enum ModifierScope
{
	UNIT,
	TOWER,
	GENERATOR,
	SCRAP_STORAGE,
	UNIT_SPAWNER
}

signal modifier_selected(modifier: SpecialModifierConfiguration)

@export_group("Modifier Selection")
@export var show_special_selection_every_n_nodes: int = 5
@export var selection_scene: PackedScene

var _selected_modifiers: Array[SpecialModifierConfiguration] = []
var _all_special_modifiers: Array[SpecialModifierConfiguration] = []
var _modifier_path: String = "res://assets/resources/modifiers/special_configuration/"


func _ready():
	await get_tree().physics_frame
	var phase_manager = GlobalDataAccess.get_phase_manager()
	phase_manager.build_phase_started.connect(_wave_ended)
	_load_possible_modifiers()
	Console.register_custom_command("show_modifier_selection", _show_modifier_popup, [], "Show the special modifier window")
	Console.register_custom_command("list_active_modifiers", _console_list_active_modifiers, [], "List all currently active modifiers")
	Console.register_custom_command("list_modifiers", _console_list_modifiers, ["(0/1) all or only currently allowed once"], "List all the modifiers available for selection")
	Console.register_custom_command("add_modifier", _console_add_modifier, ["(int) The id of the modifier to add"], "Add a specific modifier")

func _wave_ended():
	var phase_manager = GlobalDataAccess.get_phase_manager()
	var real_wave = phase_manager.current_wave - 1
	if real_wave % show_special_selection_every_n_nodes == 0:
		_show_modifier_popup()

func _show_modifier_popup():
		var popup_manager = GlobalDataAccess.get_popup_manager()
		var template = selection_scene.instantiate() as SpecialModifierScene
		template.set_possible_modifiers(_get_allowed_modifiers())
		template.modifier_was_selected.connect(_modifier_selected)
		popup_manager.show_popup(PopupPosition.FULL_SCREEN, template, true)

func _load_possible_modifiers():
	_all_special_modifiers.clear()
	for file in DirAccess.get_files_at(_modifier_path):
		var full_file_name = "%s%s" % [_modifier_path, file]
		var modifier = load(full_file_name) as SpecialModifierConfiguration
		if modifier != null:
			_all_special_modifiers.append(modifier)

	_all_special_modifiers.sort_custom(func(a,b): return a.modifier.get_display_name() < b.modifier.get_display_name())

func _get_allowed_modifiers() -> Array[SpecialModifierConfiguration]:
	var wave = GlobalDataAccess.get_phase_manager().current_wave - 1
	var allowed_modifiers: Array[SpecialModifierConfiguration] = []
	for modifier in _all_special_modifiers:
		if _selected_modifiers.any(func(selected_modifier): return selected_modifier.resource_path == modifier.resource_path):
			continue
		if modifier.selectable_after_wave > wave:
			continue
		if !_check_for_modifier_pre_requirements(modifier):
			continue

		allowed_modifiers.append(modifier)

	return allowed_modifiers

func _check_for_modifier_pre_requirements(modifier: SpecialModifierConfiguration) -> bool:
	if modifier.modifier_requirements.size() == 0:
		return true
	var return_value = true

	for requirement in modifier.modifier_requirements:
		var real_requirement = ResourceUID.get_id_path(ResourceUID.text_to_id(requirement))
		var selected_paths = _selected_modifiers.map(func(entry): return entry.resource_path)
		if !selected_paths.any(func(entry): return entry == real_requirement):
			return_value = false
			break
	return return_value

func _console_list_modifiers(all: String) -> String:
	var list_all: bool = all == "1"
	var data = _all_special_modifiers
	var cell_data: String = ""
	if !list_all:
		data = _get_allowed_modifiers()
	for modifier in data:
		var id = _all_special_modifiers.find(modifier)
		var url = Interaction.new()
		url.from_raw("enter", "add_modifier %s" % id)
		cell_data += "[cell]%s[/cell][cell][center][url=%s]%s[/url][/center][/cell][cell][right]%s[/right][/cell]" % [id, url.get_as_string(), modifier.modifier.get_display_name(), modifier.permanent]
	return "\n[p][table=3][cell][left][i]Id[/i][/left][/cell][cell][center][i]Name[/i][/center][/cell][cell][right]Permanent[/right][/cell]%s[/table][/p]\n" % cell_data

func _console_add_modifier(id: String) -> String:
	if !id.is_valid_int():
		return "[color=red]id %s was not a valid int[/color]" % id
	var real_id = int(id)
	var data = _all_special_modifiers[real_id]
	if _selected_modifiers.any(func(entry): return entry.resource_path == data.resource_path):
		return "[color=red]%s was already added[/color]" % data.modifier.get_display_name()
	_modifier_selected(data)

	return "Add %s" % data.modifier.get_display_name()

func _console_list_active_modifiers() -> String:
	var cell_data: String = ""
	for selected in _selected_modifiers:
		var id = _all_special_modifiers.find(selected)
		cell_data += "[cell][left]%s[/left][/cell][cell][right]%s[/right][/cell]" % [id, selected.modifier.get_display_name()]
	return "\n[p][table=2][cell][left][i]id[/i][/left][/cell][cell][right][i]Name[/i][/right][/cell]%s[/table][/p]\n" % cell_data

func get_active_modifiers() -> Array[SpecialModifierConfiguration]:
	return _selected_modifiers

func filter_by_type(modifier: SpecialModifierConfiguration, scope: ModifierScope) -> bool:
	if modifier.scope & (1 << scope):
		return true
	return false

func _modifier_selected(modifier: SpecialModifierConfiguration):
	if modifier.permanent:
		_selected_modifiers.append(modifier)
	modifier_selected.emit(modifier)

func _exit_tree():
	Console.remove_command("show_modifier_selection")
	Console.remove_command("list_active_modifiers")
	Console.remove_command("list_modifiers")
	Console.remove_command("add_modifier")