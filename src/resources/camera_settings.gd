class_name CameraSettings extends Resource

@export_group("Movement")
@export var mouse_drag_enabled: bool = false
@export var edge_move_enabled: bool = false
@export var move_speed: float = 15
@export var drag_speed: float = 5
@export var edge_scroll_speed: float = 10

@export_group("Smoothing")
@export var use_position_smoothing: bool = true
@export var position_smoothing_speed: float = 10

@export_group("Zoom")
@export var min_zoom: float = 1
@export var max_zoom: float = 15
@export var zoom_steps: float = 0.1
@export var zoom_duration: float = 0.2