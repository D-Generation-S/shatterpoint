class_name MessageTemplate extends Control

signal message_vanished()

@export var in_animation_time: float = 0.5
@export var vanish_time_in_seconds: float = 0.5

@onready var icon_node: TextureRect = $"%Icon"
@onready var message_node: Label = $"%Message"
@onready var timer: Timer = $"%Timer"

var text: String
var icon_texture: Texture
var time_to_show: float

var animation_tween: Tween

func _ready():
	var alternative_modulate = modulate
	modulate.a = 0
	message_node.text = tr(text)
	icon_node.texture = icon_texture

	timer.timeout.connect(_destroy)
	timer.wait_time = time_to_show

	animation_tween = create_tween()
	animation_tween.finished.connect(func(): timer.start())
	animation_tween.set_ease(Tween.EASE_OUT)
	animation_tween.tween_property(self, "modulate", alternative_modulate, in_animation_time)

func setup(message: String, timer_in_seconds: float, icon: Texture = null):
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

