extends ColorRect

func _ready():
	set_anchors_preset(Control.PRESET_CENTER)

func set_position_and_size(rect: Rect2):
	size = rect.size
	position = rect.position 
	position.x += size.x / 2

func pulse_animate():
	pass