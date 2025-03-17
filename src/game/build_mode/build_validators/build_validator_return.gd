class_name BuildValidatorReturn extends Resource

var _can_build: bool = false
var _error_message: String = ""

func _init(can_build: bool, error_message: String):
	_can_build = can_build
	_error_message = error_message

func get_can_build() -> bool:
	return _can_build

func get_error_message() -> String:
	return _error_message