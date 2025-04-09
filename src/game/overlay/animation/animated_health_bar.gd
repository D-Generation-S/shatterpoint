class_name AnimatedHealthBar extends ProgressBar

signal bar_is_shown()
signal bar_is_hidden()

@export var animation_time = 0.3
@export var always_show: bool = false
@export var auto_hide_if_full: bool = true
@export var flash_if_low: bool = true
@export var lower_flash_alpha: float = 0.5

var tween: Tween
var flash_tween: Tween
var real_value: float
var force_show_bar: bool

func _ready():
	process_mode = PROCESS_MODE_PAUSABLE
	visible = always_show
	if always_show:
		auto_hide_if_full = false
	visibility_changed.connect(_visibility_changed)

func _visibility_changed():
	if visible:
		print("visible: %s" % name)
		bar_is_shown.emit()
	else:
		print("hidden: %s" % name)
		bar_is_hidden.emit()
	

func set_max_health(new_max_health: float):
	if new_max_health <= 0:
		visible = false
	elif always_show:
		visible = true
	elif value < new_max_health:
			visible = true
	
	max_value = new_max_health

func update_value(new_value: float):
	if new_value < max_value:
		visible = true
	if new_value <= 0:
		visible = false

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

func force_show():
	force_show_bar = true
	show()

func reset_show_options():
	force_show_bar = false
	_check_auto_hide()

func _check_auto_hide():
	print ("auto check %s" % name)
	if value < max_value:
		visible = true
		return
	
	if force_show_bar:
		return
	if auto_hide_if_full and value == max_value:
		visible = false
