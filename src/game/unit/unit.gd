class_name Enemy extends EntityWithStats

signal entity_data_changed(entity_data: UnitData)

signal is_in_debug()
signal selection_changed(is_selected: bool)

@export var is_debug: bool = false
@export var start_ready: bool = false
@export var enemy_data: UnitData 

func _ready():
	_base_stats = enemy_data.stats.duplicate()
	super()
	entity_data_changed.emit(enemy_data)

	is_in_debug.emit(is_debug)
	process_mode = PROCESS_MODE_DISABLED
	if start_ready:
		activate()

	GlobalDataAccess.get_modifier_system().modifier_selected.connect(_add_global_modifier)
	for modifier in GlobalDataAccess.get_modifier_system().get_active_modifiers():
		_add_global_modifier(modifier)

func was_selected():
	selection_changed.emit(true)

func was_deselected():
	selection_changed.emit(false)

func _hp_reached_zero():
	super()

func activate():
	process_mode = PROCESS_MODE_INHERIT

func add_projectile_requested(projectile: Projectile):
	get_parent().add_child(projectile)
	
func _add_global_modifier(modifier: SpecialModifierConfiguration):
		add_modifier(modifier.modifier)