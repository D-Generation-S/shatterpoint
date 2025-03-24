extends Node2D

signal show_detail_window(request_position: Vector2, size: Vector2, title: String, content: Array[DefaultDetailContent])
signal change_threat_method(new_method: ThreatDetermination)
signal modifier_added(modifier: StatModifier)

@export var settings_content: PackedScene
@export var statistic_content: PackedScene
@export var modifiers_to_generate: int = 3

var stored_data: TowerData
var data_showed: bool = false
var current_threat_determination: ThreatDetermination

var last_data_statistic: DefaultDetailContent

var modifiers_for_round: Array[StatModifier]
var block_modifier_generator: bool = false

func _ready():
	GlobalDataAccess.get_phase_manager().dynamic_start_wave_preparation.connect(generate_new_modifiers_for_wave)

func got_selected(on: bool):
	if !on or data_showed:
		return
	var content: Array[DefaultDetailContent] = []		
	var settings = settings_content.instantiate() as TowerSettingContent

	settings.set_content_name("SETTINGS")
	var pre_selected_thread: int = 0
	for i in range(stored_data.allowed_thread_determination.size()):
		if stored_data.allowed_thread_determination[i] == current_threat_determination:
			pre_selected_thread = i
			break
	var modifications = stored_data.possible_generators.duplicate()

	modifications.shuffle()
	
	settings.setup(stored_data.allowed_thread_determination, modifiers_for_round, block_modifier_generator, pre_selected_thread)
	settings.threat_changed.connect(threat_changed)
	settings.threat_changed.connect(tell_threat_changed)

	settings.modification_added.connect(func(modifier): 
		block_modifier_generator = true
		modifier_added.emit(modifier)
		)

	var statistic = statistic_content.instantiate() as TowerStatisticContent
	statistic.statistic_updated(stored_data)
	statistic.set_content_name("STATISTIC")
	statistic.tree_exiting.connect(func(): last_data_statistic = null)

	content.append(settings)
	content.append(statistic)
	statistic.tree_exiting.connect(func(): data_showed = false)
	last_data_statistic = statistic 
	show_detail_window.emit(global_position, Vector2(300,400), "TOWER_OPTIONS", content)
	data_showed = true

func threat_changed(threat: ThreatDetermination):
	current_threat_determination = threat

func tell_threat_changed(threat: ThreatDetermination):
	change_threat_method.emit(threat)

func data_was_changed(data: BuildingBase):
	if data is TowerData:
		stored_data = data
	check_if_modifier_need_generating()
	
	if last_data_statistic == null || last_data_statistic.is_queued_for_deletion():
		return
	last_data_statistic.statistic_updated(data)

func check_if_modifier_need_generating():
	if block_modifier_generator:
		return
	
	if modifiers_for_round == null ||  modifiers_for_round.size() == 0:
		generate_new_modifiers_for_wave(GlobalDataAccess.get_phase_manager().current_wave - 1)

func generate_new_modifiers_for_wave(wave_number: int):
	modifiers_for_round = []
	block_modifier_generator = false
	for i in range(modifiers_to_generate):
		var generator = stored_data.possible_generators.filter(func(generator_template): return generator_template.is_valid(wave_number)).pick_random()
		if generator == null:
			break
		modifiers_for_round.append(generator.generate_stats(wave_number))