class_name CollisionAreaWithOverlay extends CollisionShape2D

signal size_changed(size: Rect2)

@export var color: Color = Color.CADET_BLUE
@export var max_alpha: float = 0.6
@export var min_alpha: float = 0.2

var draw_active: bool = false
var current_color: Color
var tween: Tween

# Called when the node enters the scene tree for the first time.
func _ready():
	size_changed.emit(_get_rectangle_size())
	current_color = color
	current_color.a = max_alpha
	queue_redraw()

func _get_rectangle_size() -> Rect2:
	if shape is RectangleShape2D:
		return shape.get_rect()
	return Rect2(0,0,0,0)

func _draw():
	if draw_active:
		draw_rect(_get_rectangle_size(), current_color, true)

func show_drawing():
	draw_active = true
	_animate()
	queue_redraw()
	

func _animate():
	tween = create_tween()
	tween.tween_method(set_color_alpha, max_alpha, min_alpha, 2)
	tween.tween_method(set_color_alpha, min_alpha, max_alpha, 2)
	tween.finished.connect(_animate)

func set_color_alpha(alpha: float):
	current_color.a = alpha
	queue_redraw()

func hide_drawing():
	draw_active = false
	queue_redraw()
	tween.kill()
	current_color.a = max_alpha

