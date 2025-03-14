class_name ResourceOverlay extends CanvasLayer

signal scrap_updated(new_value: int)
signal set_max_health(min: int, max: int)
signal hp_updated(new_value: int)
signal game_lost()

@export var max_scrap: int = 99999
@export var max_city_health: int = 1000


var _current_scrap: int = 25
var _current_city_hp: int = 0

func _ready():
	_current_city_hp = max_city_health
	scrap_updated.emit(_current_scrap)
	set_max_health.emit(0, _current_city_hp)
	hp_updated.emit(_current_city_hp)

func add_scrap(value: int):
	_current_scrap += value
	clampi(_current_scrap, 0, max_scrap)
	scrap_updated.emit(_current_scrap)
	
func take_city_damage(value: int):
	_current_city_hp -= value
	var clamped_hp: int = clampi(_current_city_hp, 0, max_city_health)
	hp_updated.emit(clamped_hp)
	if _current_city_hp <= 0:
		game_lost.emit()

func get_scrap():
	return _current_scrap