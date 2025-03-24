class_name EntityDetailWindowSystem extends CanvasLayer

@export var default_window_template: PackedScene
@export var popup_window_group: String = "popup_window"

func _ready():
	if default_window_template == null:
		printerr("No default window template set")

	

func request_window(position: Vector2, size: Vector2, title: String, content: Array[DefaultDetailContent]):
	var template = default_window_template.instantiate() as DefaultWindow
	if template == null:
		printerr("template was not using default window")
		return
	template.setup(Rect2(position, size), title, content)
	template.add_to_group(popup_window_group)
	add_child(template)