extends ProgressBar

@export var time_for_animation: float = 0.2
@export var should_animated_first_set: bool = false

var real_value = 0

var already_set: bool = false
var tween: Tween = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_min_and_max_value(min: int, max: int):
	min_value = min
	max_value = max

func set_current_value(new_value: int):
	var clamped = clampi(new_value, min_value, max_value)
	
	if not already_set and not should_animated_first_set:
		real_value = new_value
		value = new_value
		already_set = true
		return
	
	real_value = new_value
	tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_method(_animation_step, value, real_value, time_for_animation)
	
func _animation_step(new_value: int):
	value = new_value