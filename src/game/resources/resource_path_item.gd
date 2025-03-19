class_name ResourcePath extends Node2D

signal finished()

@onready var path: Path2D = $"%AnimationPath"
@onready var follower: PathFollow2D = $"%Follower"
@onready var icon: Sprite2D = $"%Icon"

var stored_icon: Texture
var stored_start: Node2D
var stored_end: Node2D
var stored_travel_time: float

var tween: Tween

func _ready():
	icon.texture = stored_icon
	rebuild_curve()

	tween = create_tween()
	tween.tween_method(update_travel_distance, 0.0, 1.0, stored_travel_time)
	tween.finished.connect(_destroy)

func rebuild_curve():
	path.curve = Curve2D.new()
	path.curve.add_point(stored_start.global_position)
	path.curve.add_point(stored_end.global_position)

func setup(travel_time: float, new_icon: Texture, start_point: Node2D, end_point: Node2D):
	stored_icon = new_icon
	stored_start = start_point
	stored_end = end_point
	stored_travel_time = travel_time


func update_travel_distance(distance: float):
	rebuild_curve()
	follower.progress_ratio = distance

func _destroy():
	tween.kill()
	tween = create_tween()
	var new_modulate = icon.modulate
	new_modulate.a = 0
	tween.tween_property(icon, "modulate", new_modulate, 0.2)
	tween.finished.connect(func(): 
		queue_free()
		finished.emit()
	)
