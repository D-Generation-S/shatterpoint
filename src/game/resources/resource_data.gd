class_name ResourceData extends Resource


@export_group("Scrap")
@export var _start_scrap: int = 25
@export var _max_scrap: int = 9999
@export_group("Power")
@export var _max_power: float = 0
@export_group("City")
@export var _max_city_hp: int = 1000


var _scrap: int = 0
var _power: float = 0
var _city_hp: int = 0

func startup():
	_scrap = _start_scrap
	_city_hp = _max_city_hp

func get_scrap() -> int:
	return _scrap

func get_power() -> float:
	return _power

func set_max_power(amount: float):
	_max_power = amount

func get_max_power() -> float:
	return _max_power

func change_power(amount: float) -> bool:
	if _power + amount < 0:
		return false
	_power += amount
	_power = clampf(_power, 0, _max_power)

	return true

func change_scrap(amount: int) -> bool:
	if _scrap + amount < 0:
		return false

	_scrap += amount 
	_scrap = clampi(_scrap, 0, _max_scrap)
	return true

func get_hp() -> int:
	return _city_hp

func change_hp(amount: int):
	_city_hp += amount
