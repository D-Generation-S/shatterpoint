extends Node

signal game_tick()

var ticks_per_minute = 20

var tick_time: float = 0
var current_delta_seconds: float = 0

func _ready():
	disable()
	tick_time = 60.0 / ticks_per_minute
	current_delta_seconds = 0

func _physics_process(_delta):
	current_delta_seconds += _delta
	if current_delta_seconds >= tick_time:
		game_tick.emit()
		current_delta_seconds = current_delta_seconds - tick_time

func enable():
	process_mode = PROCESS_MODE_INHERIT

func disable():
	process_mode = PROCESS_MODE_DISABLED
	