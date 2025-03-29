class_name EntityWithStats extends Node2D

signal health_changed(value: float)
signal max_health_changed(new_max_health: float)

signal armor_changed(value: float)
signal max_armor_changed(new_max_health: float)

signal request_message(target: int, style: MessageStyle, message: String, time_to_show: float, message_icon: Texture)

@export var _base_stats: EntityStats

var _base_stats_copy: EntityStats
var stats: EntityStats

var stat_modifiers: Array[StatModifier]

var is_alive: bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	_copy_stats()
	stats.max_hp = stats.hp
	max_health_changed.emit(stats.max_hp)
	max_armor_changed.emit(stats.armor)
	health_changed.emit(stats.hp)
	armor_changed.emit(stats.armor)
	request_message.connect(GlobalDataAccess.get_message_area().add_new_message)
	
func _copy_stats():
	var copy_stats: bool = stats != null
	var current_hp = 0
	var current_max_hp = 1
	if copy_stats:
		current_hp = stats.hp
		current_max_hp = stats.max_hp

	_base_stats_copy = _base_stats.duplicate()
	stats = _base_stats_copy.duplicate()

	if copy_stats:
		stats.hp = current_hp
		stats.max_hp = current_max_hp

func add_modifier(modifier: StatModifier):
	stat_modifiers.append(modifier)
	_calculate_modifier_stats()

func remove_modifier(_modifier: StatModifier):
	printerr("Not implemented")

func deal_damage(damage: float, penetration_percentage: float):
	if damage < 0:
		stats.hp -= damage
		health_changed.emit(stats.hp)
		return
	if not is_alive:
		return
	var penetration_damage = calculate_penetration_damage(damage, penetration_percentage)
	stats.hp -= penetration_damage

	var damage_left = damage - penetration_damage
	if damage_left <= 0:
		return
	if stats.armor > 0:
		var real_armor = stats.armor * 2
		real_armor -= damage_left
		stats.armor = real_armor / 2
		armor_changed.emit(stats.armor)
		if real_armor < 0:
			damage_left = -real_armor
			real_armor = 0
		else:
			damage_left = 0

	stats.hp -= damage_left
	stats.hp = clampf(stats.hp, 0, stats.max_hp)
	health_changed.emit(stats.hp)
	if stats.hp <= 0:
		_hp_reached_zero()
		_is_dying()

func calculate_penetration_damage(damage: float, penetration_percentage: float) -> float:
	var percentage = clampf(penetration_percentage, 0, 1)
	return damage * percentage

func _hp_reached_zero():
	pass

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
