class_name ResourcePathItemFollower extends PathFollow2D

signal finished()

var visuals: Sprite2D
var planned_trave_time: float

var tween: Tween

func _init(texture: Texture, travel_time: float):
	visuals = Sprite2D.new()
	visuals.texture = texture
	
	planned_trave_time = travel_time
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(visuals)

	tween = create_tween()
	tween.tween_method(update_travel_distance, 0.0, 1.0, planned_trave_time)
	tween.finished.connect(_destroy)

func update_travel_distance(distance: float):
	progress_ratio = distance

func _destroy():
	tween.kill()
	tween = create_tween()
	var new_modulate = visuals.modulate
	new_modulate.a = 0
	tween.tween_property(visuals, "modulate", new_modulate, 0.2)
	tween.finished.connect(func(): 
		queue_free()
		finished.emit()
	)
