class_name EntityWithStats extends Node2D

@export var _base_stats: EntityStats

var _base_stats_copy: EntityStats
var stats: EntityStats

var stat_modifiers: Array[StatModifier]

# Called when the node enters the scene tree for the first time.
func _ready():
	_copy_stats()
	
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

func _calculate_modifier_stats():
	_copy_stats()
	stat_modifiers.sort_custom(func(a,b): return a.priority < b.priority)
	for modifier in stat_modifiers:
		modifier.change_stats(_base_stats_copy, stats)
