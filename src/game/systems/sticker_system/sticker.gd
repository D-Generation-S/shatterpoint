class_name Sticker extends Sprite2D
 
var target_position: Vector2
var time_to_life: float
var planned_texture: Texture
var tween: Tween


# Called when the node enters the scene tree for the first time.
func _ready():
	texture = planned_texture
	global_position = target_position
	tween = create_tween()
	var target_modulate = modulate
	target_modulate.a = 0.0
	tween.tween_property(self, "modulate", target_modulate, time_to_life)
	tween.set_ease(Tween.EASE_IN)
	tween.finished.connect(_destroy)

func _init(global_target_position: Vector2,  icon: Texture, ttl: float, initial_alpha: float):
	time_to_life = ttl
	target_position = global_target_position
	modulate.a = initial_alpha

	planned_texture = icon

func _destroy():
	queue_free()

