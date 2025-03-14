class_name ResourceOverlay extends CanvasLayer

signal scrap_updated(new_value: int)
signal set_max_health(min: int, max: int)
signal hp_updated(new_value: int)
signal game_lost()

@export var max_scrap: int = 99999
@export var max_city_health: int = 1000


var current_scrap: int = 0
var current_city_hp: int = 0
func _ready():
	current_city_hp = max_city_health
	scrap_updated.emit(current_scrap)
	set_max_health.emit(0, current_city_hp)
	hp_updated.emit(current_city_hp)


func add_scrap(value: int):
	current_scrap += value
	clampi(current_scrap, 0, max_scrap)
	scrap_updated.emit(current_scrap)
	
func take_city_damage(value: int):
	current_city_hp -= value
	var clamped_hp: int = clampi(current_city_hp, 0, max_city_health)
	hp_updated.emit(clamped_hp)
	if current_city_hp <= 0:
		game_lost.emit()