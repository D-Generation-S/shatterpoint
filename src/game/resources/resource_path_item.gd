class_name ResourcePath extends Node2D

signal finished()

@onready var path: Path2D = $"%AnimationPath"

var stored_icon: Texture
var stored_start: Node2D
var stored_end: Node2D
var stored_travel_time: float
var number_of_items: int
var min_spawn_interval: float
var max_spawn_interval: float

var tween: Tween
var items_left_for_spawning: int
var destroyed_items: int = 0
var spawn_interval_timer: Timer

func _ready():
	_rebuild_curve()	
	_setup_timer()

	spawn_interval_timer.start()

func _process(_delta):
	if number_of_items == destroyed_items:
		finished.emit()
		queue_free()

	_rebuild_curve()

func _rebuild_curve():
	path.curve = Curve2D.new()
	path.curve.add_point(stored_start.global_position)
	path.curve.add_point(stored_end.global_position)

func _setup_timer() -> void:	
	spawn_interval_timer.wait_time = randf_range(min_spawn_interval, max_spawn_interval)
	spawn_interval_timer.one_shot = true
	spawn_interval_timer.autostart = false

func _timer_finished() -> void:
	if items_left_for_spawning <= 0:
		return
	
	_add_travel_item()
	
	spawn_interval_timer.wait_time = randf_range(min_spawn_interval, max_spawn_interval)
	spawn_interval_timer.start()

func _add_travel_item():
	var item = ResourcePathItemFollower.new(stored_icon, stored_travel_time)
	item.finished.connect(_trave_item_destroyed)
	path.add_child(item)
	items_left_for_spawning -= 1

func setup(
		travel_time: float,
		new_icon: Texture,
		start_point: Node2D,
		end_point: Node2D,
		set_number_of_items: int,
		set_min_spawn_interval: float,
		set_max_spawn_interval: float,):
	stored_icon = new_icon
	stored_start = start_point
	stored_end = end_point
	stored_travel_time = travel_time
	number_of_items = set_number_of_items
	min_spawn_interval = set_min_spawn_interval
	max_spawn_interval = set_max_spawn_interval
	items_left_for_spawning = number_of_items

	spawn_interval_timer = Timer.new()
	spawn_interval_timer.timeout.connect(_timer_finished)
	add_child(spawn_interval_timer)
	_setup_timer()

func _trave_item_destroyed():
	destroyed_items += 1
