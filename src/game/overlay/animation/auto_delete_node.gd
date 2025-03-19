class_name AutoDeleteNode extends Node2D

var timer: Timer
var is_debug: bool
var target_position: Vector2

func _init(time_to_life: float, node_global_position: Vector2, debug: bool = false):
	timer = Timer.new()
	timer.autostart = false
	timer.one_shot = true
	timer.wait_time = time_to_life
	timer.timeout.connect(destroy)

	target_position = node_global_position

	add_child(timer)
	is_debug = debug

# Called when the node enters the scene tree for the first time.
func _ready():
	global_position = target_position
	timer.start()
	z_index = 1000

func destroy():
	queue_free()

func _draw():
	if !is_debug:
		draw_circle(global_position, 20, Color.DARK_RED, true)
