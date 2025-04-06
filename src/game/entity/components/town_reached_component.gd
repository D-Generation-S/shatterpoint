extends Node2D

signal destroy_requested()

@export var parent_to_compare: Node2D

var is_alive: bool = false
var overlay: ResourceOverlay
var current_hp: float

func _ready():
	is_alive = true
	for town in get_tree().get_nodes_in_group("town"):
		if town is EnemyTargetArea:
			town.town_was_reached.connect(town_reached)

	overlay = GlobalDataAccess.get_resource_overlay()

func stats_updated(unit_data: UnitData):
	current_hp = unit_data.stats.hp

func died():
	is_alive = false

func town_reached(body: Node2D):
	if not is_alive:
		return
	if body == parent_to_compare:
		is_alive = false
		destroy_requested.emit()
		overlay.take_city_damage(int(current_hp))