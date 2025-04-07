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

@export_group("Entity Groups")
@export var tower_group: String = "tower"
@export var unit_group: String = "player_unit"
@export var generator_group: String = "generator"
@export var scrap_storage_group: String = "storage"

var _selected_modifiers: Array[SpecialModifierConfiguration] = []


func _ready():
	await get_tree().physics_frame
	var phase_manager = GlobalDataAccess.get_phase_manager()
	phase_manager.build_phase_started.connect(_wave_ended)

func _wave_ended():
	var phase_manager = GlobalDataAccess.get_phase_manager()
	var real_wave = phase_manager.current_wave - 1
	if real_wave % show_special_selection_every_n_nodes == 0:
		var popup_manager = GlobalDataAccess.get_popup_manager()
		var template = selection_scene.instantiate() as SpecialModifierScene
		template.modifier_was_selected.connect(_modifier_selected)
		popup_manager.show_popup(PopupPosition.FULL_SCREEN, template, true)

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