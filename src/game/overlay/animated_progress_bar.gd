extends ProgressBar

@export var time_for_animation: float = 0.2
@export var should_animated_first_set: bool = false

var real_value = 0

var already_set: bool = false
var tween: Tween = null

func set_min_and_max_value(new_min: int, new_max: int):
	min_value = new_min
	max_value = new_max

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

func set_max_value(new_max: float):
	max_value = new_max