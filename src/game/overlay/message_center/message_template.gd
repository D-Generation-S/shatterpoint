class_name MessageTemplate extends Control

signal message_vanished()
signal icon_changed(texture: Texture2D)
signal text_changed(text: String)
signal font_color_changed(color: Color)
signal theme_color_changed(name: String, color: Color)

@export var in_animation_time: float = 0.5
@export var vanish_time_in_seconds: float = 0.5

var timer

var text: String
var icon_texture: Texture
var time_to_show: float
var message_style: MessageStyle

var animation_tween: Tween

func _ready():
	var alternative_modulate = modulate
	modulate.a = 0
	text_changed.emit(tr(text))
	font_color_changed.emit(message_style.text_color)
	theme_color_changed.emit("font_color", message_style.text_color)
	icon_changed.emit(icon_texture)

	timer = Timer.new()
	timer.autostart = false
	timer.one_shot = true

	timer.timeout.connect(_destroy)
	timer.wait_time = time_to_show
	add_child(timer)

	animation_tween = create_tween()
	animation_tween.finished.connect(func(): timer.start())
	animation_tween.set_ease(Tween.EASE_OUT)
	animation_tween.tween_property(self, "modulate", alternative_modulate, in_animation_time)

func setup(style: MessageStyle, message: String, timer_in_seconds: float, icon: Texture = null):
	message_style = style
	icon_texture = icon
	text = tr(message)
	time_to_show = timer_in_seconds

func _destroy():
	var alternative_modulate = modulate
	alternative_modulate.a = 0

	animation_tween = create_tween()
	animation_tween.finished.connect(func(): 
		queue_free()
		message_vanished.emit()
		)
	animation_tween.set_ease(Tween.EASE_IN)
	animation_tween.tween_property(self, "modulate", alternative_modulate, vanish_time_in_seconds)
