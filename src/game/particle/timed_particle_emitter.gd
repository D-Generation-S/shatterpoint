extends GPUParticles2D

signal completed()
signal emitter_stopped(fadeout_time: float)

@export var min_time_to_life_in_seconds: float = 5
@export var max_time_to_life_in_seconds: float = 15
@export var min_start_delay_in_seconds: float = 0.1
@export var max_start_delay_in_seconds: float = 0.3
@export var begin_started: bool = false

var start_delay: Timer
var timer: Timer

func _init():
	emitting = begin_started

# Called when the node enters the scene tree for the first time.
func _ready():
	timer = Timer.new()
	timer.one_shot = true
	timer.autostart = false
	timer.wait_time = randf_range(min_time_to_life_in_seconds, max_time_to_life_in_seconds)
	timer.timeout.connect(_animation_done)

	start_delay = Timer.new()
	start_delay.one_shot = true
	start_delay.autostart = false
	start_delay.wait_time = randf_range(min_start_delay_in_seconds, max_start_delay_in_seconds)
	start_delay.timeout.connect(_start_animation_now)

	add_child(timer)
	if begin_started:
		_start_animation_now()
	else:
		add_child(start_delay)
		start_delay.start()

	finished.connect(_animation_completed)

func _start_animation_now():
	restart()
	timer.start()

func _animation_done():
	timer.wait_time = lifetime
	timer.timeout.disconnect(_animation_done)
	timer.timeout.connect(_animation_completed)
	timer.start()
	emitter_stopped.emit(lifetime)
	emitting = false

func _animation_completed():
	completed.emit()
	pass	
	
