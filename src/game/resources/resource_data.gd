class_name ResourceData extends Resource


@export var _start_scrap: int = 25
@export var _max_scrap: int = 9999
@export var _max_city_hp: int = 1000

var _scrap: int = 0
var _city_hp: int = 0

func startup():
	_scrap = _start_scrap
	_city_hp = _max_city_hp

func get_scrap():
	return _scrap

func change_scrap(amount: int) -> bool:
	if _scrap + amount < 0:
		return false

	_scrap += amount 
	_scrap = clampi(_scrap, 0, _max_scrap)
	return true

func get_hp():
	return _city_hp

func change_hp(amount: int):
	_city_hp += amount
