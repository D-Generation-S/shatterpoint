@tool
extends Label

@export var time_for_animation: float = 0.2
@export var animate_on_first_set: bool = false

var already_set: bool = false
var tween: Tween = null

var real_value = 0
var fake_value = 0

func set_value_animated(new_value: int):
	if not already_set and not animate_on_first_set:
		real_value = new_value
		fake_value = new_value
		text = str(fake_value)
		already_set = true
		return

	real_value = new_value
	tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_method(_animation_step, fake_value, real_value, time_for_animation)

func _animation_step(value: int):
	fake_value = value
	text = str(fake_value)	

func _update_tooltip(current_value: float, max_value: float):
	tooltip_text = "%s / %s" % [current_value, max_value]