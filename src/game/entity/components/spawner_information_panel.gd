extends Node2D

signal spawn_requested(data: UnitData)
signal show_detail_window(request_position: Vector2, size: Vector2, title: String, content: Array[DefaultDetailContent], close_others: bool)

@export var spawn_overview: PackedScene

var spawn_templates: Array[UnitData]
var data_showed: bool = false
var can_be_selected: bool = true

func _ready():
	GlobalDataAccess.get_phase_manager().wave_phase_started.connect(_wave_started)
	GlobalDataAccess.get_phase_manager().build_phase_started.connect(_build_started)

func data_updated(data: BuildingBase):
	if data is SpawnerStats:
		spawn_templates = data.possible_units

func _build_started():
	can_be_selected = true
		

func _wave_started():
	can_be_selected = false
	if data_showed:
		GlobalDataAccess.get_entity_detail_system().close_all_windows()


func got_selected(on: bool):
	if !on or data_showed or !can_be_selected:
		return

	var content: Array[DefaultDetailContent] = []	
	var spawner_popup = spawn_overview.instantiate() as SpawnerPopup
	spawner_popup.update_spawn_templates(spawn_templates)
	spawner_popup.spawn_requested.connect(_spawn_was_requested)
	spawner_popup.tree_exited.connect(func(): data_showed = false)

	content.append(spawner_popup)

	show_detail_window.emit(global_position, Vector2(300,400), tr("UNIT_SPAWN"), content)

	data_showed = true
	
func _spawn_was_requested(data: UnitData):
	spawn_requested.emit(data)

	
