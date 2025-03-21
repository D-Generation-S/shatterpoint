class_name TargetingComponent extends EntityComponent

signal new_target_found(entity: EntityWithStats)
signal attack_radius_changed(new_value: float)
signal draw_attack_radius_changed(on: bool)
signal active_state_changed(on: bool)

signal change_body_or_shape_entered(body_is_active: bool, shape_is_active: bool)

@export var main_entity: EntityWithStats
@export var area_of_operation: Area2D
@export var scan_character: bool = true
@export var scan_area: bool = false
@export_flags_2d_physics  var collision_mask: int = 2

var groups_to_attack: Array[String] = []
var current_thread_determination: ThreatDetermination

var initial_fire: bool = true

func _ready():
	if area_of_operation == null:
		printerr("Area of Operation is missing")
	if main_entity == null:
		printerr("No main entity was set")
	change_body_or_shape_entered.emit(scan_character, scan_area)
	area_of_operation.collision_mask = collision_mask
	disable()

func _process(_delta):
	var possible_targets = []
	if scan_character:
		possible_targets = area_of_operation.get_overlapping_bodies().filter(target_filter)
	if scan_area:
		possible_targets.append_array(area_of_operation.get_overlapping_areas().map(make_sure_its_entity_with_stats).filter(target_filter))
	var enemy_targets: Array[EntityWithStats] = []
	for target in possible_targets:
		if target is EntityWithStats:
			enemy_targets.append(target)
	if enemy_targets.size() == 0:
		disable()
		return
	
	var current_target = current_thread_determination.get_threat(main_entity, enemy_targets)
	new_target_found.emit(current_target)

func make_sure_its_entity_with_stats(target: Node2D) -> EntityWithStats:
	if target is Area2D:
		target = target.get_parent()
	return target

func target_filter(target: Node2D) -> bool:
	var can_be_targeted = false
	
	if target is EntityWithStats:
		for group in target.get_groups():
			if is_valid_target_group(group):
				can_be_targeted = true
				break
	return can_be_targeted

func set_attack_groups(groups: Array[String]):
	groups_to_attack = groups

func is_valid_target_group(group: String):
	return groups_to_attack.find(group) != -1

func set_current_threat_determination(thread_determination: ThreatDetermination):
	current_thread_determination = thread_determination

func draw_attack_radius(on: bool):
	draw_attack_radius_changed.emit(on)

func set_radius(radius: float):
	attack_radius_changed.emit(radius)

func enable():
	super()
	active_state_changed.emit(true)

func disable():
	super()
	active_state_changed.emit(false)