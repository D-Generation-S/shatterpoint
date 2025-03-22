extends TextureButton


@export var hover_color: Color
#@export var clicked_color: Color

var default_color: Color

func _ready():
	default_color = modulate
	mouse_entered.connect(_mouse_enter)
	mouse_exited.connect(_mouse_exit)


func _mouse_enter():
	modulate = hover_color

func _mouse_exit():
	modulate = default_color