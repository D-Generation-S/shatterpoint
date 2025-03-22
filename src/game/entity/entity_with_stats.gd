class_name EntityWithStats extends Node2D

signal health_changed(value: float)
signal max_health_changed(new_max_health: float)

@export var _base_stats: EntityStats

var _base_stats_copy: EntityStats
var stats: EntityStats

var stat_modifiers: Array[StatModifier]

var _last_position: Vector2 = Vector2.ZERO

var is_alive: bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	_copy_stats()
	stats.max_hp = stats.hp
	max_health_changed.emit(stats.max_hp)
	health_changed.emit(stats.hp)
	
func _copy_stats():
	var copy_stats: bool = stats != null
	var current_hp = 0
	if copy_stats:
		current_hp = stats.hp

	_base_stats_copy = _base_stats.duplicate()
	stats = _base_stats_copy.duplicate()

	if copy_stats:
		stats.hp = current_hp

func add_modifier(modifier: StatModifier):
	stat_modifiers.append(modifier)
	_calculate_modifier_stats()

func remove_modifier(_modifier: StatModifier):
	printerr("Not implemented")

func deal_damage(damage: float):
	if not is_alive:
		return
	stats.hp -= damage
	stats.hp = clampf(stats.hp, 0, stats.max_hp)
	health_changed.emit(stats.hp)
	#_health_bar.update_value(stats.hp)
	if stats.hp <= 0:
		_is_dying()

func _is_dying():
	is_alive = false
	queue_free()

func destroy():
	_is_dying()

func get_hp():
	return stats.hp

func _calculate_modifier_stats():
	_copy_stats()
	stat_modifiers.sort_custom(func(a,b): return a.priority < b.priority)
	for modifier in stat_modifiers:
		modifier.change_stats(_base_stats_copy, stats)