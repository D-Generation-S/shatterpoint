class_name AnimatedHealthBar extends ProgressBar

@export var animation_time = 0.3
@export var auto_hide_if_full: bool = true
@export var flash_if_low: bool = true
@export var lower_flash_alpha: float = 0.5

var tween: Tween
var flash_tween: Tween
var real_value: float

func _ready():
	process_mode = PROCESS_MODE_PAUSABLE

func update_value(new_value: float):
	if new_value < max_value:
		visible = true

	if new_value <= max_value * 0.05:
		_flashing()
	else:
		if flash_tween != null:
			flash_tween.kill()
			flash_tween = null
		modulate.a = 1
	tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "value", new_value, animation_time)
	tween.finished.connect(_check_auto_hide)

func _flashing():
	if !flash_if_low:
		return
	flash_tween = create_tween()
	flash_tween.tween_method(_change_modulate, modulate.a, lower_flash_alpha, 0.3)
	flash_tween.tween_method(_change_modulate, lower_flash_alpha, 1, 0.3)
	flash_tween.finished.connect(_flashing)

func _change_modulate(alpha: float):
	modulate.a = alpha

func _check_auto_hide():
	if value < max_value:
		visible = true
		return

	if auto_hide_if_full and value == max_value:
		visible = false
