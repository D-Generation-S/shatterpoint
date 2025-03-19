class_name ResourcePathAnimation extends Node2D

signal finished()

@export_group("Visual")
@export var icon: Texture
@export var start_point: Node2D
@export var end_point: Node2D
@export var travel_time: float = 1.6
@export var path_template: PackedScene

@export_group("Animation")
@export var number_of_items: float
@export var min_spawn_delay_in_seconds: float = 0.005
@export var max_spawn_delay_in_seconds: float = 0.05
@export var path_root_node: Node2D

@onready var timer: Timer = $"%Timer"

# Called when the node enters the scene tree for the first time.
func _ready():
	setup_timer()
	timer.start()

func setup_timer() -> void:	
	timer.wait_time = randf_range(min_spawn_delay_in_seconds, max_spawn_delay_in_seconds)
	timer.timeout.connect(timer_finished)

func timer_finished() -> void:
	if number_of_items <= 0:
		return
	
	var path = create_new_path()
	path_root_node.add_child(path)

	number_of_items -= 1
	
	timer.wait_time = randf_range(min_spawn_delay_in_seconds, max_spawn_delay_in_seconds)
	timer.start()

func _check_for_deletion():
	if path_root_node.get_children().filter(func(child): return !child.is_queued_for_deletion).size() == 0:
		finished.emit()
		queue_free()

func create_new_path() -> ResourcePath:
	var template = path_template.instantiate() as ResourcePath
	template.finished.connect(_check_for_deletion)
	template.setup(travel_time, icon, start_point, end_point)

	return template
