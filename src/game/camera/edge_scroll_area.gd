class_name EdgeScrollArea extends PanelContainer

signal edge_triggered(vector: Vector2)

@export var move_vector: Vector2
@export var min_size: float = 25
@export var is_debug: bool = false

var mouse_inside: bool = false

func _ready():
	custom_minimum_size = Vector2.ONE * min_size
	mouse_filter = MouseFilter.MOUSE_FILTER_PASS
	mouse_entered.connect(_mouse_entered)
	mouse_exited.connect(_mouse_left)
	if !is_debug:
		modulate.a = 0


func _process(_delta):
	if !mouse_inside:
		return
	edge_triggered.emit(move_vector)

func _mouse_entered():
	mouse_inside = true

func _mouse_left():
	mouse_inside = false

