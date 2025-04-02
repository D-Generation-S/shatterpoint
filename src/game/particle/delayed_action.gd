class_name DelayedAction extends Node

var delay: float = 0
var action_to_call: Callable
var arguments_to_use: PackedStringArray

func _init(delay_in_seconds: float, action: Callable, arguments: PackedStringArray = []):
	delay = delay_in_seconds
	action_to_call = action
	arguments_to_use = arguments

func _ready():
	var timer = Timer.new()
	timer.one_shot = true
	timer.autostart = false
	timer.wait_time = delay
	timer.timeout.connect(_trigger_now)

	add_child(timer)
	timer.start()

func _trigger_now():
	action_to_call.callv(arguments_to_use)
	queue_free()
	